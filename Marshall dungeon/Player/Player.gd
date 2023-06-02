extends KinematicBody2D

#--------------------------------Vida-------------------------------------------------
var alive:bool =true
export (int) var  max_health=10
var health:int =3;

var hited = false
var direction_hited

#---------------------------------movimiento---------------------------------------------
export (float, 20,200) var Motion_Speed = 100;
var congelado = false
#---------------------------------disparo---------------------------------------------
export(PackedScene) var bulletScene = load("res://Powers/Basic_Shoot.tscn")
var b_origin_offset = Vector2()
export (float) var shot_offset = 10 

var ready_shoot_1 = true
var ready_shoot_2 = true

var power_list = []
var actual_power = 0
signal Add_new_Power
export (int, 1,200)var damage = 5
#---------------------------------------status------------------------------------------

var status_base = 0
var status= status_base
onready var original_stats=[Motion_Speed,damage]

func _physics_process(delta):
	
	if alive :
		motion_ctrl(delta)
		atack_ctrl()


func atack_ctrl() ->void:
	
	if Input.is_action_pressed("Atack_normal") and ready_shoot_1:
			var goal = get_global_mouse_position()
			ready_shoot_1 = false
			$basic_shoot_timer.start()
			shoot(goal)
	
	if Input.is_action_pressed("Atack_special") and actual_power != 0 and ready_shoot_2:
			var goal = get_global_mouse_position()
			ready_shoot_2=false
			$Special_soot_Timer.start()
			shoot(goal,true)
	
	

func motion_ctrl(delta: float) -> void:
	var motion = Vector2();
	if !hited:
		if (Input.is_action_pressed("ui_up")):
			motion += Vector2(0, -1);
			#direction = "up";
		if (Input.is_action_pressed("ui_down")):
			motion += Vector2(0, 1)
			#direction ="down";
		if (Input.is_action_pressed("ui_left")):
			motion += Vector2(-1, 0)
			#direction = "left";
		if (Input.is_action_pressed("ui_right")):
			motion += Vector2(1, 0)
			#direction = "right";
		
		motion = motion.normalized() * Motion_Speed* delta;
		
		var collision = move_and_collide(motion)
		
		if collision: 
			pass;
		
	else:
			move_and_collide(direction_hited*Motion_Speed*delta)
	


func shoot( b_destination, b_explode = false):
	
	b_origin_offset = global_position.direction_to(b_destination)*shot_offset;
	var bullet = bulletScene.instance()
	
	bullet.explode = b_explode
	bullet.position = global_position+b_origin_offset
	bullet.direction = b_origin_offset.normalized()
	bullet.goal = b_destination
	if b_explode:
		bullet.explosion_power = power_list[actual_power-1]
		bullet.atribute = power_list[actual_power]
	
	
	get_tree().current_scene.add_child(bullet)
	

func hit(damage , atribute, direction):
	
	if !hited:
		$hit_timer.start()
		health =health-damage
		
		if(health <=0):
			die();
		else:
			direction_hited =  direction.direction_to(global_position)
			hited = true;
			Atribe_change(atribute)

func die():
	alive = false
	hide()
	emit_signal("dead")

func cure(var hp_restored : int):
	
	health += hp_restored;
	if health > max_health:
		health= max_health


func Atribe_change(new_status) -> void:
	if status != new_status and new_status != 0:
		match status:
			1: 
				if new_status == 3 :
					afectar_propiedades(0,damage,true)
				elif new_status ==2:
					restore_properties()
			2: 
				restore_properties()
			3: 
				if new_status == 2 :
					restore_properties()
				elif new_status == 1:
					afectar_propiedades(0,damage,true)
			_:
				status = new_status
				apply_status()
	

func apply_status():
	match status:
		1:
			afectar_propiedades(Motion_Speed,damage/2)
		2:
			burning()
		3:
			afectar_propiedades(Motion_Speed*0.65,damage)
		_:
			pass
	$Status_Timer.start(10)

func afectar_propiedades(afected_vel:float, afected_dmg:int, congelar:bool =false):
	Motion_Speed = afected_vel 
	damage = afected_dmg	
	congelado=congelar
	if congelar:
		$Status_Timer.start(5)

func restore_properties():
	status=status_base
	$Burn_Timer.stop()
	afectar_propiedades( original_stats[0], original_stats[1])

func burning()->void:
	if status==2:
		$Burn_Timer.start()
		var burn_dmg = max_health*0.01
		if burn_dmg < 1: burn_dmg = 1
		health -= burn_dmg
		if health <= 0: die()



#--------------------------------------------------------------------------------

func get_path():
	return get_node(".")


func Add_power(Explosion_atribe, Explosion_route, Explosion_att_Value):
	power_list.append(Explosion_route)
	power_list.append(Explosion_att_Value)
	emit_signal("Add_new_Power",Explosion_atribe)

func _on_Control_change_spell_atribute(new_atribute):
	actual_power = new_atribute*2 -1

func _on_hit_timer_timeout():
	hited = false;

func _on_basic_shoot_timer_timeout():
	ready_shoot_1 = true

func _on_Special_soot_Timer_timeout():
	ready_shoot_2 = true


func _on_Status_Timer_timeout():
	status = 0

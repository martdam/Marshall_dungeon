extends KinematicBody2D

#------------------------------------Vida-------------------------------------------------
var alive:bool =true
export (int) var  max_health=10
var health:int =3;
signal dead

var hited = false
var direction_hited

#---------------------------------movimiento---------------------------------------------
export (float, 20,200) var Motion_Speed = 100;
var congelado = false

#----------------------------------animacion---------------------------------------------
onready var animation_tree = get_node("AnimationTree")
onready var animation_mode = animation_tree.get("parameters/playback")

#-----------------------------------disparo---------------------------------------------
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
	
	if Input.is_action_pressed("Atack_special") and actual_power > 0 and ready_shoot_2:
			var goal = get_global_mouse_position()
			ready_shoot_2=false
			$Special_soot_Timer.start()
			shoot(goal,true)
	
	

func motion_ctrl(delta: float) -> void:
	var motion = Vector2();
	if !hited:
		if (Input.is_action_pressed("ui_up")):
			motion += Vector2(0, -1);
			
		if (Input.is_action_pressed("ui_down")):
			motion += Vector2(0, 1)
			
		if (Input.is_action_pressed("ui_left")):
			$AnimatedSprite.flip_h=true
			$AnimatedSprite/PlayerHand2/Weapons.rotation_degrees = -18 
			motion += Vector2(-1, 0)
			
		if (Input.is_action_pressed("ui_right")):
			motion += Vector2(1, 0)
			
			$AnimatedSprite/PlayerHand2/Weapons.rotation_degrees = 18
			$AnimatedSprite.flip_h = false
		
		if motion != Vector2.ZERO:
			animation_tree.set("parameters/conditions/moving",true);
			animation_tree.set("parameters/conditions/idle",false);
			animation_tree.set("parameters/Run/blend_position",motion);
		else:
			intercambiar_manos()
			animation_tree.set("parameters/conditions/idle",true);
			animation_tree.set("parameters/conditions/moving",false);
		
		motion = motion.normalized() * Motion_Speed* delta;
		
		move_and_collide(motion)
		
		
		
	else:
			move_and_collide(direction_hited*Motion_Speed*delta)
	


func shoot( b_destination, b_explode = false):
	
	
	animation_tree.set("parameters/conditions/attack",true);
	b_origin_offset = global_position.direction_to(b_destination)*shot_offset;
	var bullet = bulletScene.instance()
	
	bullet.explode = b_explode
	bullet.position = global_position+b_origin_offset
	bullet.direction = b_origin_offset.normalized()
	bullet.goal = b_destination
	if b_explode:
		bullet.explosion_power = power_list[actual_power-1]
		bullet.atribute = power_list[actual_power]
		print( power_list[actual_power])
	
	
	get_tree().current_scene.add_child(bullet)
	

func hit(damage , atribute, direction):
	
	
	if !hited and alive:
		$hit_timer.start()
		health =health-damage
		
		animation_tree.set("parameters/conditions/hurt",true);
		if(health <=0):
			
			animation_tree.set("parameters/conditions/live",false);
			animation_tree.set("parameters/conditions/dead",true);
			die();
		else:
			direction_hited =  direction.direction_to(global_position)
			hited = true;
			Atribe_change(atribute)

func die():
	alive = false
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
	var color_stat
	match status:
		1:
			color_stat = Color(0.321569, 0.4, 0.631373)
			afectar_propiedades(Motion_Speed,damage/2)
		2:
			color_stat = Color(1, 0.505882, 0.333333)
			burning()
		3:
			color_stat = Color(0.458824, 0.941176, 1)
			afectar_propiedades(Motion_Speed*0.65,damage)
		_:
			color_stat = Color.white
	
	material.set_shader_param("color",color_stat)
	$Status_Timer.start(10)

func afectar_propiedades(afected_vel:float, afected_dmg:int, congelar:bool =false):
	Motion_Speed = afected_vel 
	damage = afected_dmg	
	congelado=congelar
	if congelar:
		
		material.set_shader_param("color", Color(0.458824, 0.941176, 1))
		material.set_shader_param("froze",congelar)
		$Status_Timer.start(5)

func restore_properties():
	
	status=status_base
	$Burn_Timer.stop()
	material.set_shader_param("color", Color.white)
	material.set_shader_param("froze",false)
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

func _on_Burn_Timer_timeout():
	burning()

func intercambiar_manos() ->void:
	var value =-1
	if $AnimatedSprite.flip_h:
		value =1
	$AnimatedSprite/PlayerHand.z_index = -value
	$AnimatedSprite/PlayerHand2.z_index = value  
	

extends KinematicBody2D

#--------------------------------Vida-------------------------------------------------
var alive:bool =true
export (int) var  max_hp=10
var healt:int =3;

var hited = false
var direction_hited

#---------------------------------movimiento---------------------------------------------
export (float) var Motion_Speed = 100;

#---------------------------------disparo---------------------------------------------
export(PackedScene) var bulletScene = load("res://Powers/Basic_Shoot.tscn")
var b_origin_offset = Vector2()
export (float) var shot_offset = 10 setget _set_shot_offset

var ready_shoot_1 = true
var ready_shoot_2 = true

var power_list = []
var actual_power = 0
signal Add_new_Power

#---------------------------------------status------------------------------------------

var status= 0


func _physics_process(delta):
	
	if alive :
		motion_ctrl(delta)
		atack_ctrl()


func atack_ctrl() ->void:
	
	if Input.is_action_pressed("Atack_normal") and ready_shoot_1:
			var goal = get_global_mouse_position()
			ready_shoot_1 = false
			$basic_shoot_timer.start()
			shoot("",goal)
	
	if Input.is_action_pressed("Atack_special") and actual_power != 0 and ready_shoot_2:
			var goal = get_global_mouse_position()
			ready_shoot_2=false
			$Special_soot_Timer.start()
			shoot(power_list[actual_power-1],goal)
	
	

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
	


func shoot(atribute, destination):
	
	b_origin_offset = global_position.direction_to(destination)*shot_offset;
	var bullet = bulletScene.instance()
	
	bullet.position = global_position+b_origin_offset
	bullet.direction = b_origin_offset.normalized()
	bullet.goal = destination	
	bullet.atribute = atribute
	
	get_tree().current_scene.add_child(bullet)
	

func hit(damage , atribute, direction):
	if !hited:
		$hit_timer.start()
		healt =healt-damage
		
		if(healt <=0):
			die();
		else:
			direction_hited =  direction
			hited = true;
			Atribe_change(atribute)

func die():
	alive = false
	hide()
	emit_signal("dead")

func cure(var hp_restored : int):
	
	healt += hp_restored;
	if healt > max_hp:
		healt= max_hp



func Atribe_change(new_status):
	match status:
		1: 
			if new_status == 3 :
				pass
			elif new_status ==2:
				pass
		2: 
			if new_status ==1:
				pass
		3: 
			if new_status == 2 :
				pass
		_:
			status = new_status



func get_path():
	return get_node(".")


func Add_power(Explosion_atribe,Explosion_route):
	power_list.append(Explosion_route)
	emit_signal("Add_new_Power",Explosion_atribe)
	

func _set_shot_offset(value):
	shot_offset = value

func _on_Control_change_spell_atribute(new_atribute):
	actual_power = new_atribute
	

func _on_hit_timer_timeout():
	hited = false;

func _on_basic_shoot_timer_timeout():
	ready_shoot_1 = true

func _on_Special_soot_Timer_timeout():
	ready_shoot_2 = true

extends KinematicBody2D

#--------------------------------Vida-------------------------------------------------
var alive =true;
var lives =3;

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






# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


func _input(event):
	
	if event.is_action_pressed("left_click") and ready_shoot_1:
			var goal = get_global_mouse_position()
			ready_shoot_1 = false
			$basic_shoot_timer.start()
			shoot("",goal)
	
	if event.is_action_pressed("right_click") and actual_power != 0 and ready_shoot_2:
			var goal = get_global_mouse_position()
			ready_shoot_2=false
			$Special_soot_Timer.start()
			shoot(power_list[actual_power-1],goal)
	
	

func _physics_process(delta):
	
	var motion = Vector2();
	if alive and !hited:
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
		
	elif hited:
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
		lives =lives-1
		
		if(lives <=0):
			die();
		else:
			direction_hited =  direction
			hited = true;
			Atribe_change(atribute)

func die():
	alive = false
	hide()
	emit_signal("dead")

func cure():
	if lives<3:
		lives+=1;


func _set_shot_offset(value):
	shot_offset = value
	if Engine.editor_hint:
		update()


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


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func _on_Control_change_spell_atribute(new_atribute):
	actual_power = new_atribute
	


func Add_power(Explosion_atribe,Explosion_route):
	
	power_list.append(Explosion_route)
	emit_signal("Add_new_Power",Explosion_atribe)


func _on_hit_timer_timeout():
	hited = false;
	pass # Replace with function body.


func _on_basic_shoot_timer_timeout():
	ready_shoot_1 = true
	pass # Replace with function body.


func _on_Special_soot_Timer_timeout():
	ready_shoot_2 = true
	pass # Replace with function body.

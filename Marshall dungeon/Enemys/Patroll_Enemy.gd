extends KinematicBody2D


export (int,1,20) var max_healt = 3
var health:int = max_healt

export (float, 1 , 150) var MAX_SPEED = 10.0

var motion=Vector2()
var status_base =0
var status=0

var velocity = Vector2.ZERO

onready var player 

export var patroll_point =[]
var actual_pat_point = 0

var Ready_to_attack = true

enum {
	PATROLL,
	ATTACK,
	DODGE,
	CHASE,
}

var random_num
var target

var state = PATROLL

func _ready():
	patroll_point.append(global_position)
	add_patroll_points()

func add_patroll_points():
	var assd = get_parent().get_children()
	for n in range(1,get_parent().get_child_count()):
		patroll_point.append(get_parent().get_child(n).global_position)
	print(patroll_point)

func new_rand_position():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	random_num = rng.randfn()

func _physics_process(delta):
	match state:
		CHASE:
			move(player.global_position,delta)
		ATTACK:
			Attack()
		PATROLL:
			
			if global_position.distance_to(patroll_point[actual_pat_point]) <5 :
				
				actualizar_PP()
			move(patroll_point[actual_pat_point],delta)
		DODGE:
			if!Ready_to_attack:
				move(get_circle_position(random_num,100),delta)
			else:
				state= ATTACK
			

func actualizar_PP() ->void:
	
	if patroll_point.size() !=1:
		actual_pat_point+=1
	
	if patroll_point.size()<= actual_pat_point:
		
		
		actual_pat_point = 0
	

func Attack():
	if Ready_to_attack:
		Ready_to_attack = false
		$Attack_Timer.start()
	else:
		new_rand_position()
		state = DODGE



func move (target,delta):
	var direction = (target -global_position).normalized()
	var desired_velocity = direction * MAX_SPEED
	var steering = (desired_velocity - velocity) *delta * 2.5
	velocity +=steering
	velocity = move_and_slide(velocity)



func get_circle_position(random , radio = 50):
	
	var circle_center = player.global_position
	var angle = random * (PI*2)
	var x = circle_center.x + cos(angle)*radio
	var y = circle_center.y + sin(angle)*radio

	
	return Vector2(x,y)











# Called when the node enters the scene tree for the first time.



func Atribe_change(new_status):
	match status:
		1: 
			if new_status == 3 :
				pass
			elif new_status ==2:
				status = 0
		2: 
			if new_status ==1:
				status=0
		3: 
			if new_status == 2 :
				pass
		_:
			status = new_status
	if status_base!=0:
		status = status_base

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Detection_Area_body_entered(body):
	if body.is_in_group("Player"):
		player = body.get_path()
		state = CHASE


func _on_Detection_Area_body_exited(body):
	state = PATROLL 

func _on_Attack_Area2_body_entered(body):
	if body.is_in_group("Player"):
		state = ATTACK

func _on_Attack_Area2_body_exited(body):
	state = CHASE


func _on_Attack_Timer_timeout():
	Ready_to_attack = true
	

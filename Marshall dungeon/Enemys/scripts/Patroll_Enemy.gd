extends KinematicBody2D

#---------------------------base att-------------------------------------
export (int,1,50) var max_healt = 30
var health:int = max_healt
export (int,0,3) var status_base =0
var status=status_base

export (int, -1,3) var Weak_against_att= -1
export (int, -1,3) var Strong_against_att= -1
onready var original_stats = [MAX_SPEED,damage]

#---------------------------movement-------------------------------------
export (float, 1 , 150) var MAX_SPEED = 50.0
onready var player 
var motion=Vector2()
var velocity = Vector2.ZERO
var random_num
export var patroll_point =[]
var actual_pat_point = 0
var congelado = false

#----------------------------attack---------------------------------------
var Ready_to_attack = true
export (int,1,100) var damage = 5
export (PackedScene) var bulletScene = load("res://Powers/Enemy_Shoot.tscn")
export (bool) var explode = false
export (PackedScene) var explosionScene = load("res://Powers/Enemy_Shoot.tscn")
var b_origin_offset =Vector2()
export (float) var shoot_offset = 10
export (int) var Shoot_att = 0

#-----------------------state machine--------------------------------------
enum {
	PATROLL,
	ATTACK,
	DODGE,
	CHASE,
}
var state = PATROLL

#----------------------------------------------------------------
func _ready():
	add_patroll_points()

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
		_:
			state=PATROLL
	

#-------------------------extra functions-------------------------
func new_rand_number() -> void:
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	random_num = rng.randfn()

#-------------------------movement functions-------------------------
func add_patroll_points() -> void:
	for n in range(0,get_parent().get_child_count()):
		patroll_point.append(get_parent().get_child(n).global_position)

func actualizar_PP() -> void:
	if patroll_point.size() !=1:
		actual_pat_point+=1	
	if patroll_point.size()<= actual_pat_point:
		actual_pat_point = 0

func move(target,delta) -> void:
	var direction = (target -global_position).normalized()
	var desired_velocity = direction * MAX_SPEED
	var steering = (desired_velocity - velocity) *delta * 2.5
	velocity +=steering
	velocity = move_and_slide(velocity)

func get_circle_position(random , radio = 50) -> Vector2:
	var circle_center = player.global_position
	var angle = random * (PI*2)
	var x = circle_center.x + cos(angle)*radio
	var y = circle_center.y + sin(angle)*radio
	return Vector2(x,y)

#-------------------------combat functions-------------------------
func Attack() -> void:
	if Ready_to_attack and !congelado:
		Ready_to_attack = false
		shoot(Shoot_att, player.global_position, explode)
		$Attack_Timer.start()
	else:
		new_rand_number()
		state = DODGE


func shoot(b_atribute, b_destination, b_explode = false):
	
	b_origin_offset = global_position.direction_to(b_destination)*shoot_offset;
	var bullet = bulletScene.instance()
	
	bullet.explode = b_explode
	bullet.position = global_position+b_origin_offset
	bullet.direction = b_origin_offset.normalized()
	bullet.goal = b_destination
	bullet.atribute = b_atribute
	if b_explode:
		bullet.explosion_power = explosionScene

	get_tree().current_scene.add_child(bullet)
	


func hit(damage_taked , hit_att, direction):
	var hit_modifier 
	match hit_att:
		Strong_against_att: 
			hit_modifier = 0.5
		Weak_against_att:
			hit_modifier = 2
		_:
			hit_modifier =1
	
	health -= damage_taked*hit_modifier
	
	if(health <=0):
		die();
	else:
		Atribe_change(hit_att)

func die(): 
	queue_free()

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
			afectar_propiedades(MAX_SPEED,damage/2)
		2:
			color_stat = Color(1, 0.505882, 0.333333)
			burning()
		3:
			color_stat = Color(0.458824, 0.941176, 1)
			afectar_propiedades(MAX_SPEED*0.6,damage)
		_:
			color_stat = Color.white
	
	material.set_shader_param("color",color_stat)
	$Status_Timer.start(10)

func afectar_propiedades(afected_vel:float, afected_dmg:int, congelar:bool =false):
	MAX_SPEED = afected_vel 
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
		var burn_dmg = max_healt*0.01
		if burn_dmg < 1: burn_dmg = 1
		health -= burn_dmg
		if health <= 0: die()

#-------------------------link functions-------------------------
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

func _on_Status_Timer_timeout():
	restore_properties()

func _on_Burn_Timer_timeout():
	burning()

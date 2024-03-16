extends KinematicBody2D

#---------------------------base att-------------------------------------
export (int,1,50) var max_healt = 10
var health:int = max_healt
export (int,0,3) var status_base =0
var status=status_base
var congelado = false

export (int, -1,3) var Weak_against_att= -1
export (int, -1,3) var Strong_against_att= -1
onready var original_stats = [MAX_SPEED,damage]
export (bool) var die= false
export (int,0,3) var atribute=0

#---------------------------movement-------------------------------------
export (float, 1 , 150) var MAX_SPEED = 50.0

var motion=Vector2()
var velocity= Vector2.ZERO
var random_num

export var patroll_point =[]
var actual_pat_point = 0

onready var player 

var path: Array = []
var levelNavigation: Navigation2D= null


onready var lineOS = $LineOfSight

#onready var line2 = $Line2D
#var actstate = state
var point:Vector2 = Vector2.ZERO

var detect:bool = false
var in_attack_distance:bool = false
var spawnear:bool =false
#----------------------------attack---------------------------------------
var Ready_to_attack = true
var att_point 
var direction_hited
export (int, 10, 100) var attack_distance =40
export var attacking:bool = false
export (int,1,100) var damage = 5
export var hited:bool = false
export var knock_back:bool = true

#-----------------------state machine--------------------------------------
enum {
	PATROLL,
	ATTACK,
	DODGE,
	CHASE,
	WAITING,
}
var state = WAITING
var delta_t
#----------------------animation------------------------------------------

onready var animation_tree = get_node("AnimationTree")
export (bool) var moving_anim = false

#----------------------------------------------------------------
func _ready():
	yield(get_tree(),"idle_frame")
	var tree = get_tree()
	if 	tree.has_group("LevelNavigationGroup"):
		levelNavigation = tree.get_nodes_in_group("LevelNavigationGroup")[0]
	if 	tree.has_group("Player"):
		player = tree.get_nodes_in_group("Player")[0]
	add_patroll_points()
	actualizar_PP()


#-------------------------------------------------------------------------

func _physics_process(delta):
#	line2.global_position = Vector2.ZERO
	delta_t=delta
	if die:
		queue_free()
	
	if detect and player != null:
		lineOS.look_at(player.global_position)
		check_player_on_attack_distance()
	
	match state:
		
		WAITING:
			Waiting()
		CHASE:
			Chase()
		ATTACK:
			Attack()
		PATROLL:
			
			if hited:
				navigate()
			else:
				Patroll()
		DODGE:
			Dodge()
		_:
			state=PATROLL
	
#	if actstate!= state: 
#		print(actstate," - ", state)
#		actstate=state
	

#-------------------------extra functions-------------------------

func generate_path(shorter:bool = false,destiny = [Vector2.ZERO,Vector2.ZERO]):
	if player != null and levelNavigation != null:
		path = levelNavigation.get_simple_path(global_position,levelNavigation.get_closest_point(point),shorter)
	if destiny != [Vector2.ZERO,Vector2.ZERO]:
		path = destiny
#	line2.points= path

func new_rand_number() -> void:
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	random_num = rng.randfn()

func check_player_on_sight() -> bool:
	var collider = lineOS.get_collider()
	if collider != null and collider.is_in_group("Player"):
		return true
	return false

func check_player_on_attack_distance():
	
	var collider = lineOS.get_collider()
	if collider != null and collider.is_in_group("Player"):
		
		if state==WAITING and global_position.distance_to(collider.global_position)< attack_distance*1.5:
			spawnear= true
			set_collision_layer_bit(2,true)
			
		if  global_position.distance_to(collider.global_position)<= attack_distance :
			in_attack_distance = true
		else:
			in_attack_distance = false
			attacking=false

func add_patroll_points() -> void:
	for n in range(0,get_child_count()):
		if get_child(n) is Position2D:
			patroll_point.append(get_child(n).global_position)
	if patroll_point.size() == 0:
		patroll_point.append(global_position)

func actualizar_PP() -> void:
	if patroll_point.size() >1:
		actual_pat_point+=1	
		if patroll_point.size()<= actual_pat_point:
			actual_pat_point = 0
		point = patroll_point[actual_pat_point]
		generate_path()

func get_circle_position(random , radio = 50) -> Vector2:
	var circle_center = player.global_position
	var angle = random * (PI*2)
	var x = circle_center.x + cos(angle)*radio
	var y = circle_center.y + sin(angle)*radio
	return Vector2(x,y)

func Detectar()->void:
	detect =true
	generate_path()


#-------------------------movement functions-------------------------
func navigate(speed = MAX_SPEED):
	if !animation_tree.get("parameters/conditions/Die"):
		if knock_back and hited :
			
			move(direction_hited,delta_t)
			if global_position.direction_to(direction_hited).x > 0:
				$Sprite.flip_h=true
			else:
				$Sprite.flip_h=false
			
		elif path.size()>1:
			if global_position.direction_to(path[1]).x < 0:
				$Sprite.flip_h=true
			else:
				$Sprite.flip_h=false
			
			move(path[1],delta_t)
			velocity = global_position.direction_to(path[1])* speed
			if global_position.distance_to(path[1]) <1 :
				animation_tree.set("parameters/conditions/Run",true);
				animation_tree.set("parameters/conditions/Idle",false);
				path.pop_at(0)
			else:
				
				animation_tree.set("parameters/conditions/Run",false);
				animation_tree.set("parameters/conditions/Idle",true);

func move(target,delta, speed = MAX_SPEED) -> void:
	var direction:Vector2 = (target -global_position).normalized()
	var desired_velocity = direction * speed
	var steering = (desired_velocity - velocity) *delta * 2.5
	velocity +=steering
	velocity = move_and_slide(velocity)

func Chase():
	if check_player_on_sight():
		
		if path.size()>0 and path[path.size()-1].distance_to(player.global_position) >30:
			point =player.global_position
			generate_path(true)
		navigate()
		
		if in_attack_distance:
			state = ATTACK
	else:
		state = PATROLL

func Dodge():
	if!Ready_to_attack:
		if path.size()-1>0 and path[path.size()-1] .distance_to(get_circle_position(random_num,50)) > 40:
			point =get_circle_position(random_num,50)
			generate_path()
		navigate()
	else:
		state= ATTACK

func Patroll():
	
	if check_player_on_sight(): 
		state= CHASE
	
	if patroll_point.size()>0: 
		if global_position.distance_to(patroll_point[actual_pat_point]) <5 :
			if $yield_Timer.is_stopped():
				$yield_Timer.start(3)
			
		elif global_position.distance_to(patroll_point[actual_pat_point]) >5 :
			navigate()

func Waiting() -> void:
	if spawnear:
		animation_tree.set("parameters/conditions/Spawn",true);
		Detectar()
		if check_player_on_sight():
			state = CHASE
	else:
		pass

#-------------------------combat functions-------------------------
func Attack() -> void:
	if  check_player_on_sight() and in_attack_distance and Ready_to_attack and !congelado and !attacking :
		animation_tree.set("parameters/conditions/Run",false);
		animation_tree.set("parameters/conditions/Attack",true);
		att_point = player.global_position + (attack_distance*0.5 * global_position.direction_to(player.global_position))
		generate_path(true,[global_position,att_point])
		
	elif check_player_on_sight() and !in_attack_distance :
		animation_tree.set("parameters/conditions/Attack",false);
		state= CHASE
		
	elif !Ready_to_attack and !attacking :
		animation_tree.set("parameters/conditions/Attack",false);
		new_rand_number()
		point = get_circle_position(random_num,50)
		generate_path()
		state = DODGE
	
	if attacking:
		navigate(MAX_SPEED*3)
		Ready_to_attack = false
		$Attack_Timer.start()
		if global_position.distance_to(att_point)<=5: 
			animation_tree.set("parameters/conditions/Attack",false);
			attacking=false

func hit(damage_taked , hit_att, direction):
	var hit_modifier 
	hited = true
	direction_hited = global_position + (5 * -global_position.direction_to(direction))
	animation_tree.set("parameters/conditions/Idle",false);
	animation_tree.set("parameters/conditions/Run",false);
	animation_tree.set("parameters/conditions/Attack",false);
	animation_tree.set("parameters/conditions/Hurt",true);
	
	get_node("AudioDaño").play()
	match hit_att:
		Strong_against_att: 
			hit_modifier = 0.5
		Weak_against_att:
			hit_modifier = 2
		_:
			hit_modifier =1
	
	health -= damage_taked*hit_modifier
	if(health <=0):
		animation_tree.set("parameters/conditions/Die",true);
		get_node("AudioMuerte").play()
	else:
		Atribe_change(hit_att)

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
			restore_properties()
	
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
		
		if health -burn_dmg<=0:
			hit(burn_dmg*2,2,Vector2.LEFT)
		else:
			health -= burn_dmg
		

#-------------------------link functions-------------------------
func _on_Detection_Area_body_entered(body):
	if body.is_in_group("Player") :
		Detectar()

func _on_Detection_Area_body_exited(body):
	if body.is_in_group("Player") and spawnear:
		detect = false
		state = PATROLL 
		point = patroll_point[actual_pat_point]
		generate_path()

func _on_Attack_Timer_timeout():
	Ready_to_attack = true

func _on_Status_Timer_timeout():
	status = 0
	apply_status()

func _on_Burn_Timer_timeout():
	burning()

func _on_yielf_Timer_timeout():
	if state == PATROLL:
		actualizar_PP()

func _on_Attack_Area_body_entered(body):
	if body.collision_layer & (1) and attacking: # si choca con el jugador
		body.hit(damage,atribute,global_position)
	if body.collision_layer & (2) and attacking: # si choca con las paredes
		attacking =false
		Ready_to_attack = true
		animation_tree.set("parameters/conditions/Attack",false);


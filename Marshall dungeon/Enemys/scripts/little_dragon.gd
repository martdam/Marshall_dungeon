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

var player_onSight:bool = false

var point:Vector2 = Vector2.ZERO

var detect = false
var in_attack_distance = false

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

#----------------------animation------------------------------------------
onready var animation_tree = get_node("AnimationTree")
export (bool) var fire = false

#----------------------Procesos------------------------------------------
func _ready():
	yield(get_tree(),"idle_frame")
	var tree = get_tree()
	if 	tree.has_group("LevelNavigationGroup"):
		levelNavigation = tree.get_nodes_in_group("LevelNavigationGroup")[0]
	if 	tree.has_group("Player"):
		player = tree.get_nodes_in_group("Player")[0]
	add_patroll_points()
	actualizar_PP()


func _physics_process(delta):
	
	if die:
		queue_free()
	
	if detect and player != null:
		lineOS.look_at(player.global_position)
	
	match state:
		
		CHASE:
			chase(delta)
		ATTACK:
			Attack()
		PATROLL:
			patroll(delta)
		DODGE:
			dodge(delta)
		_:
			state=PATROLL
	

#-------------------------extra functions-------------------------
func new_rand_number() -> void:
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	random_num = rng.randfn()

func navigate(delta:float):
	if path.size()>1:
		move(path[1],delta)
		velocity = global_position.direction_to(path[1])* MAX_SPEED
		
		if global_position.distance_to(path[1]) <1 :
			animation_tree.set("parameters/conditions/Run",true);
			animation_tree.set("parameters/conditions/Idle",false);
			path.pop_at(0)
			
		else:
			animation_tree.set("parameters/conditions/Run",false);
			animation_tree.set("parameters/conditions/Idle",true);



func generate_path(shorter:bool = false):
	if player != null and levelNavigation != null:
		path = levelNavigation.get_simple_path(global_position,levelNavigation.get_closest_point(point),shorter)


func check_player_on_sight() -> bool:
	var collider = lineOS.get_collider()
	if collider != null and collider.is_in_group("Player"):
		player_onSight=true
		return true
	return false


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


#-------------------------movement functions-------------------------
func chase(delta:float):
	if player_onSight:
		if path.size()>0 and path[path.size()-1].distance_to(player.global_position) > 80:
			point =player.global_position
			generate_path(true)
		navigate(delta)
		
		if in_attack_distance:
			state = ATTACK
	else:
		state = PATROLL


func dodge(delta: float):
	if!Ready_to_attack:
		if path[path.size()-1] .distance_to(get_circle_position(random_num,50)) > 40:
			point =get_circle_position(random_num,50)
			generate_path()
		navigate(delta)
	else:
		state= ATTACK
		animation_tree.set("parameters/conditions/Stop",true);
		animation_tree.set("parameters/conditions/Run",false);


func patroll(delta: float):
	
	if player_onSight: 
		state= CHASE
	
	if patroll_point.size()>0: 
		if global_position.distance_to(patroll_point[actual_pat_point]) <5 :
			if $yield_Timer.is_stopped():
				$yield_Timer.start(3)
			
		elif global_position.distance_to(patroll_point[actual_pat_point]) >5 :
			navigate(delta)


func move(target,delta) -> void:
	var direction:Vector2 = (target -global_position).normalized()
	if direction.x < 0:
		$Sprite.flip_h=true
	else:
		$Sprite.flip_h=false
	var desired_velocity = direction * MAX_SPEED
	var steering = (desired_velocity - velocity) *delta * 2.5
	velocity +=steering
	velocity = move_and_slide(velocity)


#-------------------------combat functions-------------------------
func Attack() -> void:
	if check_player_on_sight() and Ready_to_attack and !congelado :
		
		animation_tree.set("parameters/conditions/Stop",true);
		animation_tree.set("parameters/conditions/Run",false);
		animation_tree.set("parameters/conditions/Attack",true);
		
		if fire:
			Ready_to_attack = false
			shoot(Shoot_att, player.global_position, explode)
			$Attack_Timer.start()
			fire =false
			animation_tree.set("parameters/conditions/Attack",false);
		
	elif !check_player_on_sight():
		state= CHASE
		
	elif !Ready_to_attack:
		new_rand_number()
		point = get_circle_position(random_num,50)
		generate_path()
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
	if !animation_tree.get("parameters/conditions/Run") or hit_att == Weak_against_att:
		var hit_modifier 
		
		animation_tree.set("parameters/conditions/Hurt",true);
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
		if health <= 0: 
			animation_tree.set("parameters/conditions/Hurt",true);
			animation_tree.set("parameters/conditions/Die",true);

#-------------------------link functions-------------------------
func _on_Detection_Area_body_entered(body):
	if body.is_in_group("Player") :
		detect =true
		generate_path()

func _on_Detection_Area_body_exited(body):
	if body.is_in_group("Player"):
		detect = false
		player_onSight = false
		state = PATROLL 
		point = patroll_point[actual_pat_point]
		generate_path()

func _on_Attack_Area_body_entered(body):
	if body.is_in_group("Player"):
		in_attack_distance = true
		state = ATTACK

func _on_Attack_Area_body_exited(body):
	if body.is_in_group("Player"):
		in_attack_distance = false
		animation_tree.set("parameters/conditions/Attack",false);
		state = CHASE

func _on_Attack_Timer_timeout():
	Ready_to_attack = true

func _on_Status_Timer_timeout():
	restore_properties()

func _on_Burn_Timer_timeout():
	burning()


func _on_yielf_Timer_timeout():
	if state == PATROLL:
		actualizar_PP()
	


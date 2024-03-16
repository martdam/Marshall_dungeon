extends Area2D

export var damage = 1 setget _set_damage
export (int) var atribute = 0 setget _set_atribute
var explode = false
export var goal = Vector2.ZERO setget _set_goal
export var direction = Vector2.RIGHT setget _set_direction
var extra_distance = 50
var minimun_way = Vector2(extra_distance,extra_distance)
var bullet_speed = 100
export (bool) var move = false

onready var animation_tree = get_node("AnimationTree")
export(PackedScene) var explosion_power = load("res://Powers/Basic_Shoot.tscn") setget _set_explosion
var velocity

func _ready():
	minimun_way =minimun_way*direction
	if animation_tree != null:
		match atribute:
			1:
				animation_tree.set("parameters/conditions/Water",true);
			2:  
				animation_tree.set("parameters/conditions/Fire",true);
			3:
				animation_tree.set("parameters/conditions/Ice",true);
			_:
				animation_tree.set("parameters/conditions/Normal",true);
	if explode:
		get_node("AudioSpawn2").play()
	else:
		get_node("AudioSpawn1").play()
	

func _process(delta):
	
	velocity = direction * bullet_speed 
	if move == true:
		position += velocity * delta
	
	if global_position.distance_to(goal+minimun_way) < 1 and visible:
		_end()
	

func _end():
	animation_tree.set("parameters/conditions/Water",false);
	animation_tree.set("parameters/conditions/Fire",false);
	animation_tree.set("parameters/conditions/Ice",false);
	animation_tree.set("parameters/conditions/Normal",false);
	
	move=false
	
	
	if explode:
		var explosion = explosion_power.instance()
		explosion.rotation = rotation
		explosion.position = position
		get_tree().current_scene.call_deferred("add_child",explosion)
	visible=false
	set_collision_layer_bit(4,false)
	yield(get_tree().create_timer(0.1), "timeout")
	queue_free()

func _set_atribute(value:int):
	atribute = value
	
	if value != 0:
		_set_damage(damage * 1.5)

func _set_damage(value):
	damage=value

func _set_goal(value):
	goal=value

func _set_explosion(value):
	explosion_power = load(value)

func _set_direction(value):
	direction = value
	rotation = value.angle()


func _on_Node2D_body_entered(body):
	if body.collision_layer & (1^1|1^4):
		body.hit(damage,atribute,global_position)
	get_node("AudioChoque").play()
	_end()


func _on_Node2D_area_entered(area):
	if area.collision_layer & (1^64):
		_end()
		get_node("AudioChoque").play()
	

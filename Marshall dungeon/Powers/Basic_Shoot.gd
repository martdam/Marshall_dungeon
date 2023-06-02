extends Area2D

export var damage = 1 setget _set_damage
export (int) var atribute = 0 setget _set_atribute
var explode = false
export var goal = Vector2.ZERO setget _set_goal
export var direction = Vector2.RIGHT setget _set_direction
var extra_distance = 50
var minimun_way = Vector2(extra_distance,extra_distance)
var bullet_speed = 100


export(PackedScene) var explosion_power = load("res://Powers/Basic_Shoot.tscn") setget _set_explosion


func _ready():
	minimun_way =minimun_way*direction

func _process(delta):
	var velocity
	velocity = direction * bullet_speed 
	position += velocity * delta
	if global_position.distance_to(goal+minimun_way) < 1:
		_end()
	

func _end():
	
	if explode:
		var explosion = explosion_power.instance()
		explosion.position = global_position
		get_tree().current_scene.add_child(explosion)
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
	body.hit(damage,atribute,global_position)

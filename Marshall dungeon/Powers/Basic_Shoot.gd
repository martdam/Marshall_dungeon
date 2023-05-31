extends Area2D

export var damage = 1 setget _set_damage
export (String) var atribute = "" setget _set_atribute
export var goal = Vector2.ZERO setget _set_goal
export var direction = Vector2.RIGHT setget _set_direction
var extra_distance = 50
var minimun_way = Vector2(extra_distance,extra_distance)
var bullet_speed = 100


export(PackedScene) var explosion_power = load("res://Powers/Basic_Shoot.tscn")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	minimun_way =minimun_way*direction
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity
	velocity = direction * bullet_speed 
	position += velocity * delta
	
	if global_position.distance_to(goal+minimun_way) < 1:
		_end()
		
func _end():
	
	if atribute != "":
		var explosion = explosion_power.instance()
		explosion.position = global_position
		get_tree().current_scene.add_child(explosion)
	queue_free()

func _set_atribute(value):
	atribute = value
	if value != "":
		_set_damage(damage * 2)
 
func _set_damage(value):
	damage=value

func _set_goal(value):
	goal=value


func _set_direction(value):
	direction = value
	rotation = value.angle()

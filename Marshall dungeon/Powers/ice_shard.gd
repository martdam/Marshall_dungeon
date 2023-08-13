extends Area2D

export var damage = 2 
export (int) var atribute = 3
var explode = false
export var goal = Vector2.ZERO setget _set_goal
export var direction = Vector2.RIGHT setget _set_direction
var extra_distance = 55
var minimun_way = Vector2(extra_distance,extra_distance)
var bullet_speed = 175
var chain = 0


export(PackedScene) var explosion_power = load("res://Powers/Explosions/Ice_expl.tscn") 


func _ready():
	minimun_way =minimun_way*direction
	if chain <2: 
		explode=true

func _process(delta):
	var velocity
	velocity = direction * bullet_speed 
	position += velocity * delta
	if global_position.distance_to(goal+minimun_way) < 1:
		_end()
	

func _end():
	
	if explode:
		var explosion = explosion_power.instance()
		explosion.rotation = rotation
		explosion.position = global_position
		explosion.chain = chain
		get_tree().current_scene.add_child(explosion)
	queue_free()

 
func _set_goal(value):
	goal=value


func _set_direction(value):
	direction = value
	rotation = value.angle()


func _on_Node2D_body_entered(body):
	if body.collision_layer & (1^1|1^4):
		body.hit(damage,atribute,global_position)
	queue_free()

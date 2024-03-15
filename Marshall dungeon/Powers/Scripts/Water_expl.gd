extends KinematicBody2D


var atribute = 1
var damage = 2
var direction
var goal

func _ready():
	direction = global_position.direction_to($Position2D.global_position)
	goal = $Position2D.global_position
	get_node("AudioSpawn").play()

func _process(delta):
	var velocity
	velocity = direction * 100
	position += velocity * delta

func _on_Timer_timeout():
	queue_free() 

func _on_Area2D_body_entered(body):
	if body.collision_layer & (1^1|1^4):
		body.hit(damage,atribute,global_position)
		queue_free()

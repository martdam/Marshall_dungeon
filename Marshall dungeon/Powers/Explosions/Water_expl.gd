extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var atribute = 1
var damage = 2
var direction
var goal

# Called when the node enters the scene tree for the first time.
func _ready():
	direction = global_position.direction_to($Position2D.global_position)
	goal = $Position2D.global_position
	
func _process(delta):
	
	var velocity
	velocity = direction * 100
	position += velocity * delta
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	queue_free() # Replace with function body.

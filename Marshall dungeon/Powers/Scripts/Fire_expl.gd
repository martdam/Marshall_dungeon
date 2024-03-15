extends Area2D


var damage = 1
var atribute = 2
export (bool) var finished = false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("Explode")
	get_node("AudioSpawn").play()

func _process(delta):
	if finished:
		queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_AnimationPlayer_animation_finished(Explode):
	queue_free()
	


func _on_fire_expl_body_entered(body):
	if body.collision_layer & (1^1|1^4):
		body.hit(damage,atribute,global_position)
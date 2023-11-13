extends Area2D

var damage = 1
var atribute = 0
var status =atribute
var active = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func change_active():
	set_collision_mask_bit(0,active)
	if active:
		show()
	else:
		hide()


func _on_Node2D_body_entered(body):
	body.hit(damage, atribute, global_position)


func _on_Timer_timeout():
	
	active = !active
	change_active()

func _on_trap_core_breaked():
	if get_parent() is Timer:
		get_parent().stop()
	active = false
	change_active()



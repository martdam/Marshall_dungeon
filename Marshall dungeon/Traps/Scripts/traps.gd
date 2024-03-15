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


func _on_Node2D_body_entered(body):
	if body.collision_layer ==1:
		body.hit(damage, atribute, global_position)
	

func Atribe_change(new_status):
	match status:
		1: 
			if new_status == 3:
				change_active()
		2: 
			if new_status == 1:
				change_active()
		3: 
			if new_status == 2:
				change_active()
		_:
			pass

func _on_Timer_timeout():
	active = !active

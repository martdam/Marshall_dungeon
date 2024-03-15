extends Area2D

signal pressed
var dissable:bool = false


func _on_pressure_plate_body_entered(body):
	get_node("AudioPress").play()
	$AnimatedSprite.set_frame(2) 
	emit_signal("pressed")


func _on_pressure_plate_body_exited(body):
	$AnimatedSprite.set_frame(1) 

func _on_trap_core_breaked():
	set_collision_mask_bit(0,false)

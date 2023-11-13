extends Area2D

signal pressed
var dissable:bool = false


func _on_pressure_plate_body_entered(body):
	print("pressed")
	emit_signal("pressed")


func _on_pressure_plate_body_exited(body):
	pass # Replace with function body.

func _on_trap_core_breaked():
	set_collision_mask_bit(0,false)

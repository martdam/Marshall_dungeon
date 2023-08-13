extends Area2D

signal pressed

func _on_pressure_plate_body_entered(body):
	emit_signal("pressure_plate_pressed")
	pass # Replace with function body.


func _on_pressure_plate_body_exited(body):
	pass # Replace with function body.


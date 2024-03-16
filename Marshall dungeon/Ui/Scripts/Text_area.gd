extends Area2D

export var Text= "Inserte texto aqui"
signal change_txt
signal hide_txt

func _on_Text_area_body_entered(body):
	emit_signal("change_txt",Text)



func _on_Text_area_body_exited(body):
	emit_signal("hide_txt")

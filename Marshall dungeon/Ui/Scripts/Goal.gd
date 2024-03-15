extends Area2D

export var nxt_lvl= "Tutorial"
signal change_lvl

func _on_Goal_body_entered(body):
	emit_signal("change_lvl",nxt_lvl)


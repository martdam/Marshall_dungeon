extends Area2D


export (int) var hp_restoration = 100

func _on_Heal_Potion_body_entered(body):
	body.cure(hp_restoration)
	get_node("AudioPick").play()
	visible=false
	set_collision_layer_bit(5,false)



func _on_AudioPick_finished():
	queue_free()

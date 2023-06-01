extends Area2D


export (int) var hp_restoration = 10

func _on_Heal_Potion_body_entered(body):
	body.cure(hp_restoration)
	queue_free()

extends Control


func _ready():
	get_node("AnimationPlayer").play("fade_in")

func _on_Salir_pressed():
	get_tree().quit();


func _on_Nuevo_Juego_pressed():
	get_node("AnimationPlayer").play("fade-out")


func _on_mouse_entered():
	get_node("AudioMouseOnButton").play()


func _on_button_down():
	get_node("AudioButton_Down").play()


func _on_AnimationPlayer_animation_finished(anim_name):
	match anim_name:
		"fade-out":
			get_tree().change_scene("res://Levels/Tutorial.tscn")

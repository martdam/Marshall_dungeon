extends Control


func _ready():
	get_node("AnimationPlayer").play("fade_in")
	get_node("Panel_creditos").visible=false

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


func _on_Creditos_pressed():
	get_node("Panel_creditos").visible=true


func _on_Cerrar_pressed():
	get_node("Panel_creditos").visible=false


func _on_Settings_pressed():
	get_node("settings").visible=true
	

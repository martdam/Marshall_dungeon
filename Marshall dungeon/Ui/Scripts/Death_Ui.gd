extends Control

export(String) var nivel_actual = "res://Test Area.tscn"

var nombre_escena:String

func _ready():
	visible = false


func aparecer():
	get_node("AudioAparecer").play()
	get_tree().paused = true
	get_node("AnimationPlayer").play("fade-in")
	visible=true


func _on_Salir_pressed():
	get_tree().quit()


func _on_Menu_principal_pressed():
	
	nombre_escena = "res://Main menu.tscn"
	get_node("AnimationPlayer").play("fade-out")


func _on_Restart_pressed():
	
	nombre_escena = nivel_actual
	get_node("AnimationPlayer").play("fade-out")


func _on_Player_dead():
	if !visible:
		aparecer()


func _on_AnimationPlayer_animation_finished(anim_name):
	match anim_name:
		"fade-out":
			get_tree().paused = false
			get_tree().change_scene(nombre_escena)
	



func _on_mouse_entered():
	get_node("AudioMouseOnButton").play()


func _on_button_down():
	get_node("AudioButton_Down").play()

extends Control

var nombre_escena:String

func _ready():
	get_node("AnimationPlayer").play("fade_in")

func _on_Salir_pressed():
	get_tree().quit();


func _on_mouse_entered():
	get_node("AudioMouseOnButton").play()


func _on_button_down():
	get_node("AudioButton_Down").play()


func _on_AnimationPlayer_animation_finished(anim_name):
	match anim_name:
		"fade-out":
			get_tree().change_scene(nombre_escena)


func _on_Menu_principal_pressed():
	
	nombre_escena = "res://Levels/Main Menu.tscn"
	get_node("AnimationPlayer").play("fade-out")


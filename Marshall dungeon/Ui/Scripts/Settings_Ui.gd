extends Control

func _ready():
	visible = false

func _on_mouse_entered():
	get_node("AudioMouseOnButton").play()


func _on_button_down():
	get_node("AudioButton_Down").play()


func _on_Cerrar_pressed():
	visible=false
	



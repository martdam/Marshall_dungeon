extends Control

func _ready():
	visible=true
	get_node("Node").visible = false
	

func _input(event):
	if event.is_action_pressed("Pausar"):
		get_node("AudioAparecer").play()
		get_node("Node").visible = not get_tree().paused
		get_tree().paused = not get_tree().paused


func _on_Continuar_pressed():
	get_node("AudioAparecer").play()
	get_node("Node").visible= not get_tree().paused
	get_tree().paused = not get_tree().paused


func _on_Volver_al_menu_pressed():
	get_tree().paused = not get_tree().paused
	get_tree().change_scene("res://Levels/Main Menu.tscn")


func _on_Salir_pressed():
	get_tree().quit();

func _on_mouse_entered():
	get_node("AudioMouseOnButton").play()


func _on_button_down():
	get_node("AudioButton_Down").play()


func _on_Settings_pressed():
	get_node("Node/settings").visible=true
	


func _on_pausar_pressed():
	get_node("AudioAparecer").play()
	get_node("Node").visible = not get_tree().paused
	get_tree().paused = not get_tree().paused

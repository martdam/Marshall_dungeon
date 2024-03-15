extends Control



func _on_Salir_pressed():
	get_tree().quit();


func _on_Nuevo_Juego_pressed():
	get_tree().change_scene("res://Test Area.tscn")


func _on_mouse_entered():
	get_node("AudioMouseOnButton").play()


func _on_button_down():
	get_node("AudioButton_Down").play()

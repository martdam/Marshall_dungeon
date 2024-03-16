extends Control

export var Text_label="Tutorial"

func _ready():
	visible= false
	get_node("Panel/Label").text=Text_label


func _on_Text_area_change_txt(new_text):
	get_node("AnimationPlayer").play("fade-in")
	Text_label = new_text
	get_node("Panel/Label").text=Text_label

func _on_Text_area_hide_txt():
	get_node("AnimationPlayer").play("fade_out")


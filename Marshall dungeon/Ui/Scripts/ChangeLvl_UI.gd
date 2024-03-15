extends Control

export var Nextlvl="Tutorial"

func _ready():
	visible= true
	get_tree().paused=true
	get_node("AnimationPlayer").play("fade_in")

func Change_Lvl():
	get_node("AnimationPlayer").play("fade-out")

func _on_AnimationPlayer_animation_finished(anim_name):
	match anim_name:
		"fade_in":
			get_tree().paused=false
			visible=false
		"fade-out":
			get_tree().change_scene("res://Levels/"+Nextlvl+".tscn")


func _on_Goal_change_lvl(nxt_lvl):
	visible=true
	get_tree().paused=true
	get_node("AnimationPlayer").play("fade-out")
	
	Nextlvl=nxt_lvl

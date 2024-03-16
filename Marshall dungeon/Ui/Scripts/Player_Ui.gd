extends Control
onready var player:KinematicBody2D=get_tree().get_nodes_in_group("Player")[0]

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var spell_atribute = []
var actual_spell = 0
var spell_count = 0

signal change_spell_atribute
# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("TextureProgress").max_value=player.max_health


func _process(delta):
	if is_instance_valid(player):
		get_node("TextureProgress").value= player.health

func _input(event):
	if event.is_action_pressed("cambiar_att_izq"):
		_change_spell(-1)
		emit_signal("change_spell_atribute",actual_spell)
	
	if event.is_action_pressed("cambiar_att_der"):
		_change_spell(1)
		emit_signal("change_spell_atribute",actual_spell)

func _change_spell( var sumar):
	
	if spell_count > 0:
		actual_spell += sumar
		get_node("AudioAbilityChange").play()
		if actual_spell < 1:
			actual_spell = spell_count
		elif actual_spell > spell_count:
			actual_spell=1
		
		match spell_atribute[actual_spell-1]:
			"agua":
				get_node("TextureProgress/TextureRect").frame=1
			"fuego":
				get_node("TextureProgress/TextureRect").frame=2
			"hielo":
				get_node("TextureProgress/TextureRect").frame=0
	

func _on_Player_Add_new_Power( power_att):
	spell_atribute.append(power_att)
	spell_count = spell_atribute.size()
	pass # Replace with function body.

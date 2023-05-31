extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var spell_atribute = []
var actual_spell = 0
var spell_count = 0

signal change_spell_atribute
# Called when the node enters the scene tree for the first time.
func _ready():
	$Panel/Label.text = ""


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
		
		if actual_spell < 1:
			actual_spell = spell_count
		elif actual_spell > spell_count:
			actual_spell=1
		
		$Panel/Label.text = spell_atribute[actual_spell-1]
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Player_Add_new_Power( power_att):
	spell_atribute.append(power_att)
	spell_count = spell_atribute.size()
	pass # Replace with function body.

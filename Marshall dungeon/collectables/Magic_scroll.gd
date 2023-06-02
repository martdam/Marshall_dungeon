extends Area2D


export (String) var Explosion_route = "" 
export (String) var Explosion_atribe_txt = "Agua"  
export (int,0,3 ) var Explosion_atribe_value = 1


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _on_Scroll_body_entered(body):
	
	body.Add_power(Explosion_atribe_txt,Explosion_route,Explosion_atribe_value)
	queue_free()
	


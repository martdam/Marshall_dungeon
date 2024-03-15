extends Area2D

export (String) var Explosion_route = "" 
export (String) var Explosion_atribe_txt = "Agua"  
export (int,1,3 ) var Explosion_atribe_value = 1


func _ready():
	$Sprite.set_frame(Explosion_atribe_value-1)

func _on_Scroll_body_entered(body):
	body.Add_power(Explosion_atribe_txt,Explosion_route,Explosion_atribe_value)
	get_node("AudioPick").play()
	visible=false
	set_collision_layer_bit(5,false)


func _on_AudioPick_finished():
	queue_free()

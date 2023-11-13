extends Area2D


export (int,0,3) var atribute = 0

signal breaked

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func disable(atribe):
	
	match atribute:
		1:
			if atribe == 3:
				emit_signal("breaked")
		2:
			if atribe== 1:
				emit_signal("breaked")
		3:
			if atribe == 2:
				emit_signal("breaked")
		_:
				emit_signal("breaked")


func _on_trap_core_area_entered(area):
	disable(area.atribute)

func _on_trap_core_body_entered(body):
	disable(body.atribute)

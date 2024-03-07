extends Area2D


export (int,0,3) var atribute = 0

signal breaked

# Called when the node enters the scene tree for the first time.
func _ready():
	match atribute:
		1:
			$AnimationTree.set("parameters/conditions/Agua",true);
		2:
			$AnimationTree.set("parameters/conditions/Fuego",true);
		3:
			$AnimationTree.set("parameters/conditions/Hielo",true);
		_:
			pass 


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func disable(atribe):
	
	match atribute:
		1:
			if atribe == 3:
				emit_signal("breaked")
				$AnimationTree.set("parameters/conditions/Activado",true);
		2:
			if atribe== 1:
				emit_signal("breaked")
				$AnimationTree.set("parameters/conditions/Activado",true);
		3:
			if atribe == 2:
				emit_signal("breaked")
				$AnimationTree.set("parameters/conditions/Activado",true);
		_:
				emit_signal("breaked")
				$AnimationTree.set("parameters/conditions/Activado",true);


func _on_trap_core_area_entered(area):
	disable(area.atribute)

func _on_trap_core_body_entered(body):
	disable(body.atribute)

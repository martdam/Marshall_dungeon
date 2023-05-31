extends KinematicBody2D

var status_base =0
var status=0

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func Atribe_change(new_status):
	match status:
		1: 
			if new_status == 3 :
				pass
			elif new_status ==2:
				status = 0
		2: 
			if new_status ==1:
				status=0
		3: 
			if new_status == 2 :
				pass
		_:
			status = new_status
	if status_base!=0:
		status = status_base

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

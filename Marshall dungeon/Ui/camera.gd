extends Camera2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var player = get_tree().get_nodes_in_group("Player")[0]


func _process(delta):
	global_position = player.global_position

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

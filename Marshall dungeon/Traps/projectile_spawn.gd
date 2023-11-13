extends Position2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(PackedScene) var bulletScene = load("res://Powers/Enemy_Shoot.tscn")
export (int ,0,3) var projectil_att= 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func shoot():
	
	var bullet = bulletScene.instance()
	
	bullet.explode = false
	bullet.position = global_position
	bullet.direction = global_position.direction_to($"projectile direction".global_position).normalized()
	bullet.goal = $"projectile direction".global_position
	bullet.atribute = projectil_att
	
	get_tree().current_scene.add_child(bullet)


func _on_pressure_plate_pressed():
	print("shoot")
	shoot()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

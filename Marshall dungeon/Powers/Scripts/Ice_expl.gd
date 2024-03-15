extends Area2D

export(PackedScene) var bulletScene = load("res://Powers/ice_shard.tscn")
var damage = 4
var atribute = 3
onready var array=[$Pos0.global_position,$Pos1.global_position,$Pos2.global_position,$Pos3.global_position,$Pos4.global_position,$Pos5.global_position,$Pos6.global_position,$Pos7.global_position,]
var chain=0
var ice_dir = 8
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	chain+=1
	# Replace with function body.

func shoot_shards():
	for shoot_pos in ice_dir:
		
		var bullet = bulletScene.instance()
		bullet.position = position
		bullet.direction = global_position.direction_to(array[shoot_pos]) .normalized()
		bullet.goal = global_position
		bullet.chain = chain
		bullet.damage = damage/2
		get_tree().current_scene.add_child(bullet)
		
	



func _on_Timer_timeout():
	shoot_shards()
	queue_free()


func _on_ice_expl_body_entered(body):
	if body.collision_layer & (1^1|1^4):
		body.hit(damage,atribute,global_position)
		queue_free()

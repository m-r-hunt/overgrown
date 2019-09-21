extends Node2D

export(int, 1, 4) var player_number := 1

func _ready():
	$KinematicBody2D.collision_layer |= (1 << player_number)
	# TODO Set controls somehow

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

extends Node2D

export(int, 1, 4) var player_number := 1

func _ready():
	$KinematicBody2D.collision_layer |= (1 << player_number)
	$KinematicBody2D.up_action = str("p", player_number, "_up")
	$KinematicBody2D.down_action = str("p", player_number, "_down")
	$KinematicBody2D.left_action = str("p", player_number, "_left")
	$KinematicBody2D.right_action = str("p", player_number, "_right")

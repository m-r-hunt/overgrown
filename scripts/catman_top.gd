extends Node2D

tool


export(int, 1, 4) var player_number := 1 setget set_player_number


func _ready():
	set_player_number(player_number)


func set_player_number(n):
	$KinematicBody2D.collision_layer &= ~(1 << player_number)
	player_number = n
	$KinematicBody2D.collision_layer |= (1 << player_number)
	$KinematicBody2D.up_action = str("p", player_number, "_up")
	$KinematicBody2D.down_action = str("p", player_number, "_down")
	$KinematicBody2D.left_action = str("p", player_number, "_left")
	$KinematicBody2D.right_action = str("p", player_number, "_right")
	$KinematicBody2D.interact_action = str("p", player_number, "_interact")
	$"KinematicBody2D/AsepriteSprite".texture = load(str("res://sprites/catman", player_number, ".png"))

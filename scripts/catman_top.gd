extends Node2D

export(int, 1, 4) var player_number := 1

func _ready():
	$KinematicBody2D.collision_layer |= (1 << player_number)
	#var mat_copy = $"KinematicBody2D/Aseprite Sprite".material.duplicate()
	#$"KinematicBody2D/Aseprite Sprite".material = mat_copy
	randomize()
	$"KinematicBody2D/Aseprite Sprite".material.set_shader_param("col", Color(randf(), randf(), randf()))

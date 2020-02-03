extends Node2D


func _process(_delta: float):
	if Input.is_action_just_pressed("p1_interact") or Input.is_action_just_pressed("p2_interact") or Input.is_action_just_pressed("p3_interact") or Input.is_action_just_pressed("p4_interact"):
		Utils.assert_ok(get_tree().change_scene("res://scenes/screens/farms.tscn"))

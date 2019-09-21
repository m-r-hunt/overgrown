extends Node2D


export(int, 1, 4) var allowed_player := 1


func _ready():
	Utils.e_connect($Area2D, "body_entered", self, "on_body_entered")
	Utils.e_connect($Area2D, "body_exited", self, "on_body_exited")
	$Area2D.collision_mask |= (1 << allowed_player)
	$StaticBody2D.collision_layer &= ~(1 << allowed_player)
	$StaticBody2D.collision_mask &= ~(1 << allowed_player)


func on_body_entered(_body):
	$"Aseprite Sprite/Animation Player".play("Open")


func on_body_exited(_body):
	$"Aseprite Sprite/Animation Player".play("Closed")

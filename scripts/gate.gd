extends Node2D


export(int, 1, 4) var allowed_player := 1 setget set_allowed_player


func _ready():
	Utils.e_connect($Area2D, "body_entered", self, "on_body_entered")
	Utils.e_connect($Area2D, "body_exited", self, "on_body_exited")
	set_allowed_player(allowed_player)


func set_allowed_player(p):
	$Area2D.collision_mask &= ~(1 << allowed_player)
	$StaticBody2D.collision_layer = 30
	$StaticBody2D.collision_mask = 30
	allowed_player = p
	$Area2D.collision_mask |= (1 << allowed_player)
	$StaticBody2D.collision_layer &= ~(1 << allowed_player)
	$StaticBody2D.collision_mask &= ~(1 << allowed_player)


func on_body_entered(_body):
	$AsepriteSprite/AnimationPlayer.play("Open")


func on_body_exited(_body):
	$AsepriteSprite/AnimationPlayer.play("Closed")

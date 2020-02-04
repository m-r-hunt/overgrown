extends Node2D

tool


export(int, 1, 4) var player_number := 1 setget set_player_number


func _ready():
	set_player_number(player_number)


func set_player_number(n: int):
	player_number = n
	$Sprite.texture = load(str("res://sprites/flag", player_number, ".png"))

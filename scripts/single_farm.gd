extends Node2D

tool


export(int, 1, 4) var player_number := 1 setget set_player_number
export var top_gate := false setget set_top_gate


func _ready():
	set_player_number(player_number)
	set_top_gate(top_gate)


func set_player_number(p):
	player_number = p
	$Gate.allowed_player = player_number
	$Catman.player_number = player_number
	$MoneySign.player_number = player_number


func set_top_gate(tg):
	top_gate = tg
	if top_gate:
		$Gate.position.y = 24
	else:
		$Gate.position.y = 200

extends Node2D

tool


export(int, 1, 4) var player_number := 1 setget set_player_number
export var top_gate := false setget set_top_gate
export var left_flag = false setget set_left_flag


func _ready():
	set_player_number(player_number)
	set_top_gate(top_gate)


func set_player_number(p):
	player_number = p
	$Gate.allowed_player = player_number
	$Catman.player_number = player_number
	$MoneySign.player_number = player_number
	$Flag.player_number = player_number


func set_top_gate(tg):
	top_gate = tg
	if top_gate:
		$Gate.position.y = 24
		$Flag.position.y = 10
	else:
		$Gate.position.y = 200
		$Flag.position.y = 186

func set_left_flag(lf):
	left_flag = lf
	if left_flag:
		$Flag.position.x = 24
	else:
		$Flag.position.x = 200

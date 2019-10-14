extends Node

var player_moneys := [0, 0, 0, 0]
var time := 0.0
var max_time := 60.0

func add_money(amount, player):
	player_moneys[player-1] += amount

func _process(delta):
	time += delta

func get_time_portion():
	return time / max_time

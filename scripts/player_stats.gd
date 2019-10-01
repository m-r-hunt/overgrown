extends Node

var player_moneys := [0, 0, 0, 0]

func add_money(amount, player):
	player_moneys[player-1] += amount

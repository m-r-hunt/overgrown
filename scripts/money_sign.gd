extends Node2D


export var player_number := 1


func _process(_delta: float):
	$Label.text = str(PlayerStats.player_moneys[player_number-1])

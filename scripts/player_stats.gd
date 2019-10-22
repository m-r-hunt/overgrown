extends Node


var player_moneys := [0, 0, 0, 0]
var time := 0.0
var max_time := 120.0
var started := false


signal time_started
signal time_up


func start():
	started = true
	emit_signal("time_started")


func add_money(amount, player):
	player_moneys[player-1] += amount


func _process(delta):
	if started:
		time += delta
		if time > max_time:
			emit_signal("time_up")


func get_time_portion():
	return time / max_time

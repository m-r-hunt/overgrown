extends Node


var player_moneys := [0, 0, 0, 0]
var time := 0.0
var max_time := 120.0
var started := false
var active_players := [false, false, false, false]


signal time_started
signal time_up


func reset():
	player_moneys = [0, 0, 0, 0]
	time = 0.0
	started = false


func start():
	Utils.use(active_players)
	started = true
	emit_signal("time_started")
	if ProjectSettings.get_setting("my_settings/debug/short_rounds"):
		max_time = 20


func add_money(amount, player):
	if started:
		player_moneys[player-1] += amount


func _process(delta):
	if started:
		time += delta
		if time > max_time:
			emit_signal("time_up")
			started = false


func get_time_portion():
	return time / max_time


func make_farms_scene():
	var farms = preload("res://scenes/screens/farms.tscn").instance()
	for i in range(0, 4):
		if !PlayerStats.active_players[i]:
			farms.remove_player(i)
	return farms

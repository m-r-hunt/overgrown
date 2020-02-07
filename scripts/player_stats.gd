extends Node


var player_moneys := [5, 5, 5, 5]
var time := 0.0
var max_time := 240.0
var started := false
var active_players := [true, true, false, false]


signal time_started
signal time_up


func reset():
	player_moneys = [5, 5, 5, 5]
	time = 0.0
	started = false


func start():
	Utils.use(active_players)
	started = true
	emit_signal("time_started")
	if ProjectSettings.get_setting("my_settings/debug/short_rounds"):
		max_time = 20


func has_money(amount: int, player: int) -> bool:
	return player_moneys[player-1] >= amount


func add_money(amount: int, player: int):
	if started:
		player_moneys[player-1] += amount


func spend_money(amount: int, player: int) -> bool:
	if started:
		if player_moneys[player-1] >= amount:
			player_moneys[player-1] -= amount
			return true
	return false


func _process(delta: float):
	if started:
		time += delta
		if time > max_time:
			emit_signal("time_up")
			started = false


func get_time_portion() -> float:
	return time / max_time

extends Node2D


var count := 8
var started = false

func remove_player(i):
	match i:
		0:
			$TiledMap.gate_only("TopLeft")
		1:
			$TiledMap.gate_only("TopRight")
		2:
			$TiledMap.gate_only("BottomLeft")
		3:
			$TiledMap.gate_only("BottomRight")

func _ready():
	for i in range(0, 4):
		if !PlayerStats.active_players[i]:
			remove_player(i)
	if ProjectSettings.get_setting("my_settings/debug/short_rounds"):
		count = 3
	Utils.e_connect($CountdownTimer, "timeout", self, "on_timeout")
	$Label.text = str(count)
	Utils.e_connect(PlayerStats, "time_up", self, "on_time_up")


func _process(_delta):
	if not started and (Input.is_action_just_pressed("p1_interact") or Input.is_action_just_pressed("p2_interact") or Input.is_action_just_pressed("p3_interact") or Input.is_action_just_pressed("p4_interact")):
		$CountdownTimer.start()
		$Instructions.queue_free()
		started = true
		$CountdownBeep.play()


func on_timeout():
	count -= 1
	if count >= 1:
		$Label.text = str(count)
		$CountdownBeep.play()
	elif count == 0:
		$Label.text = "GO!"
		PlayerStats.start()
		$GoBeep.play()
	else:
		$Label.text = ""
		$CountdownTimer.stop()


func on_time_up():
	$EndGong.play()
	$EndTimer.start()
	yield($EndTimer, "timeout")
	assert(get_tree().change_scene("res://scenes/screens/round_end.tscn") == OK)
	queue_free()

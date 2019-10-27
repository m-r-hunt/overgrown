extends Node2D


var count := 8
var started = false

func remove_player(i):
	match i:
		0:
			$Farms/TopLeft.gate_only()
		1:
			$Farms/TopRight.gate_only()
		2:
			$Farms/BottomLeft.gate_only()
		3:
			$Farms/BottomRight.gate_only()

func _ready():
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
	assert(get_tree().change_scene("res://scenes/screens/round_end.tscn") == OK)
	queue_free()

extends Node2D


var count := 8

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
	$CountdownTimer.start()
	$Label.text = str(count)
	

func on_timeout():
	count -= 1
	if count >= 1:
		$Label.text = str(count)
	elif count == 0:
		$Label.text = "GO!"
		$"/root/PlayerStats".start()
	else:
		$Label.text = ""
		$CountdownTimer.stop()

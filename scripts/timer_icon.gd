extends PathFollow2D


func _process(_delta: float):
	unit_offset = PlayerStats.get_time_portion()

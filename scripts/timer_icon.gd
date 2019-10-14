extends PathFollow2D


func _process(_delta):
	unit_offset = $"/root/PlayerStats".get_time_portion()

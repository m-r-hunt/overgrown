extends Node2D


func _process(_delta: float):
	var frame = ceil($AsepriteSprite.hframes * PlayerStats.get_time_portion())-1
	if frame < 0:
		frame = 0
	$AsepriteSprite.frame = frame

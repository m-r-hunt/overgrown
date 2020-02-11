extends Node2D


func _process(_delta: float):
	$AsepriteSprite.frame = floor($AsepriteSprite.hframes * PlayerStats.get_time_portion())

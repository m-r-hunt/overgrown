extends Area2D


func water():
	if has_node("Planted"):
		$"AsepriteSprite/AnimationPlayer".play("Watered")
		$Planted.water();


func reset_after_pick():
	$AsepriteSprite/AnimationPlayer.play("Fallow")


func is_empty() -> bool:
	return not has_node("Planted")

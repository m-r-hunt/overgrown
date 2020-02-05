extends Area2D


func water() -> bool:
	if has_node("Planted"):
		$AsepriteSprite/AnimationPlayer.play("Watered")
		return $Planted.water()
	else:
		return false


func reset_after_pick():
	$AsepriteSprite/AnimationPlayer.play("Fallow")


func is_empty() -> bool:
	return not has_node("Planted")

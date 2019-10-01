extends Area2D


func water():
	if has_node("Planted"):
		$"AsepriteSprite/AnimationPlayer".play("Watered")
		$Planted.water();

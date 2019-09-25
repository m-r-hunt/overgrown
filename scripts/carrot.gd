extends Area2D


enum State {
	BAG,
	GROWING,
	GROWN,
	WILTED,
	ITEM,
}


export var state := State.BAG


func pickable():
	match state:
		State.BAG, State.ITEM, State.GROWN:
			return true
		_:
			return false


func place(place: Place):
	assert(place)
	if state == State.BAG:
		get_parent().remove_child(self)
		place.target.add_child(self)
		position = Vector2.ZERO
		state = State.GROWING
		$AsepriteSprite/AnimationPlayer.play("Grow1")
		var collider = preload("res://scenes/carrot_collider.tscn").instance()
		add_child(collider)

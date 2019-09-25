extends Node2D


enum State {
	Bag,
	Growing,
	Grown,
	Wilted,
	Item,
}

export var state := State.Bag

func pickable():
	match state:
		State.Bag, State.Item, State.Grown:
			return true
		_:
			return false


func place(place):
	assert(place is Place)
	get_parent().remove_child(self)
	place.target.add_child(self)
	position = Vector2.ZERO
	state = State.Growing
	$AsepriteSprite/AnimationPlayer.play("Grow1")
	var collider = preload("res://scenes/carrot_collider.tscn").instance()
	add_child(collider)

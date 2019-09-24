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


func place_on(obj):
	get_parent().remove_child(self)
	obj.add_child(self)
	position = Vector2.ZERO

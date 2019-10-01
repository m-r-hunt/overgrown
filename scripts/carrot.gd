extends Area2D


enum State {
	BAG,
	GROWING,
	GROWN,
	WILTED,
	ITEM,
}


export var state := State.BAG


func _ready():
	Utils.e_connect($Timer, "timeout", self, "on_timeout")


func pickable():
	match state:
		State.BAG, State.ITEM:
			return true
		State.GROWN:
			state = State.ITEM
			$AsepriteSprite/AnimationPlayer.play("Item")
			remove_child(get_node("CarrotCollider"))
			return true
		_:
			return false


func place(place: Place):
	assert(place)
	assert(state == State.BAG || state == State.ITEM)
	if state == State.BAG:
		get_parent().remove_child(self)
		place.target.add_child(self)
		position = Vector2.ZERO
		state = State.GROWING
		$AsepriteSprite/AnimationPlayer.play("Grow1")
		var collider = preload("res://scenes/carrot_collider.tscn").instance()
		add_child(collider)
		collider.name = "CarrotCollider"
		name = "Planted"


func water():
	assert(state == State.GROWING)
	$AsepriteSprite/AnimationPlayer.play("Grow2")
	$Timer.start()


func on_timeout():
	assert(state == State.GROWING)
	$AsepriteSprite/AnimationPlayer.play("Grown")
	state = State.GROWN

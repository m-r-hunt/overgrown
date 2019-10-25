extends Area2D


class_name Plant


enum PlantType {
	CARROT,
	TOMATO
	MAX,
}


enum State {
	BAG,
	GROWING,
	GROWN,
	WILTED,
	ITEM,
}


export var plant_type := PlantType.CARROT
export var state := State.BAG
export var price := 10


func _ready():
	Utils.e_connect($Timer, "timeout", self, "on_timeout")
	var sprite
	match plant_type:
		PlantType.CARROT:
			sprite = preload("res://sprites/carrot.json").instance()
		PlantType.TOMATO:
			sprite = preload("res://sprites/tomato.json").instance()
	sprite.name = "AsepriteSprite"
	add_child(sprite)


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
		var collider = preload("res://scenes/objects/carrot_collider.tscn").instance()
		add_child(collider)
		collider.name = "CarrotCollider"
		name = "Planted"


func sell(sell: Sell):
	assert(sell)
	assert(state == State.BAG || state == State.ITEM)
	if state == State.ITEM:
		PlayerStats.add_money(price, sell.selling_player.player_number)
		get_parent().remove_child(self)
		queue_free()


func water():
	assert(state == State.GROWING)
	$AsepriteSprite/AnimationPlayer.play("Grow2")
	$Timer.start()


func on_timeout():
	assert(state == State.GROWING)
	$AsepriteSprite/AnimationPlayer.play("Grown")
	state = State.GROWN

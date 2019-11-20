extends Area2D


enum PlantType {
	CARROT,
	TOMATO
	MAX,
}


enum State {
	GROWING,
	GROWN,
	WILTED,
	ITEM,
}


export var state := State.GROWING
export var plant_type := PlantType.CARROT
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
		State.ITEM:
			return true
		State.GROWN:
			state = State.ITEM
			$AsepriteSprite/AnimationPlayer.play("Item")
			remove_child(get_node("CarrotCollider"))
			return true
		_:
			return false


func sell(sell: Sell):
	assert(sell)
	assert(state == State.ITEM)
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


func hold_interact():
	queue_free()
	if get_parent().has_method("reset_after_pick"):
		get_parent().reset_after_pick()
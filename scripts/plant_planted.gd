extends Area2D


enum State {
	PLANTED,
	GROWING,
	GROWN,
	WILTED,
	ITEM,
}


export var state := State.PLANTED
export var plant_type: int = Plant.PlantType.CARROT
export var price := 10


func _ready():
	Utils.e_connect($Timer, "timeout", self, "on_timeout")
	var sprite: Node2D
	match plant_type:
		Plant.PlantType.CARROT:
			sprite = load("res://sprites/carrot.json").instance()
			price = 10
			$Timer.wait_time = 3
		Plant.PlantType.TOMATO:
			sprite = load("res://sprites/tomato.json").instance()
			price = 20
			$Timer.wait_time = 8
	sprite.name = "AsepriteSprite"
	sprite.position.y = -8
	add_child(sprite)


func pickable():
	match state:
		State.ITEM:
			return true
		State.GROWN:
			state = State.ITEM
			$AsepriteSprite/AnimationPlayer.play("Item")
			remove_child(get_node("Collider"))
			return true
		_:
			return false


func sell(sell: Sell):
	assert(sell)
	assert(state == State.ITEM)
	if state == State.ITEM:
		var multiplier := 1
		if sell.target.has_method("sell_multiplier"):
			multiplier = sell.target.sell_multiplier(plant_type)
		if multiplier == 0:
			return
		PlayerStats.add_money(price * multiplier, sell.selling_player.player_number)
		get_parent().remove_child(self)
		queue_free()


func water():
	assert(state == State.PLANTED || state == State.GROWING || state == State.GROWN)
	if state == State.PLANTED:
		$AsepriteSprite/AnimationPlayer.play("Grow2")
		$Timer.start()
		state = State.GROWING


func on_timeout():
	assert(state == State.GROWING)
	$AsepriteSprite/AnimationPlayer.play("Grown")
	state = State.GROWN


func hold_interact():
	queue_free()
	if get_parent().has_method("reset_after_pick"):
		get_parent().reset_after_pick()

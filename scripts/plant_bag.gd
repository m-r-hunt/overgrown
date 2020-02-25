extends Area2D


export var plant_type: Resource = load("res://plants/carrot.tres")
export var count := 9

var bought := false


func _ready():
	assert(plant_type is PlantResource)
	var sprite := (plant_type as PlantResource).sprite.instance()
	sprite.name = "AsepriteSprite"
	add_child(sprite)
	sprite.position.y = -8
	$Label.text = str(count)
	$Label.set_as_toplevel(true)
	$CoinSprite.frame = plant_type.bag_cost-1


func _process(_delta: float):
	$Label.margin_left = global_position.x-1
	$Label.margin_right = global_position.x+7
	$Label.margin_top = global_position.y-7
	$Label.margin_bottom = global_position.y+7


func pickable(player_number: int) -> bool:
	return bought || PlayerStats.has_money(plant_type.bag_cost, player_number)


func pick(player_number: int):
	if not bought:
		assert(PlayerStats.spend_money(plant_type.bag_cost, player_number))
		bought = true
		$CoinSprite.visible = false


func place(place: Place):
	assert(place)
	if place.target.is_empty():
		count -= 1
		$Label.text = str(count)
		var planted := load("res://scenes/objects/plant_planted.tscn").instance() as Node2D
		planted.plant_type = plant_type
		place.target.add_child(planted)
		planted.position = Vector2(0, 16)
		planted.get_node("AsepriteSprite/AnimationPlayer").play("Grow1")
		var collider := preload("res://scenes/objects/planted_plant_collider.tscn").instance()
		planted.add_child(collider)
		collider.name = "Collider"
		planted.name = "Planted"

		if count == 0:
			queue_free()

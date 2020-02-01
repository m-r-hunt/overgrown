extends Area2D


class_name Plant


enum PlantType {
	CARROT,
	TOMATO
	MAX,
}


export var plant_type := PlantType.CARROT
export var count := 9

var bought := false


static func random_type():
	return randi() % PlantType.MAX


func randomise_type():
	plant_type = random_type()


static func get_sprite(type):
	match type:
		PlantType.CARROT:
			return preload("res://sprites/carrot.json").instance()
		PlantType.TOMATO:
			return preload("res://sprites/tomato.json").instance()


func _ready():
	var sprite = get_sprite(plant_type)
	sprite.name = "AsepriteSprite"
	add_child(sprite)
	sprite.position.y = -8
	$Label.text = str(count)
	$Label.set_as_toplevel(true)


func _process(_delta):
	$Label.margin_left = global_position.x-1
	$Label.margin_right = global_position.x+7
	$Label.margin_top = global_position.y-7
	$Label.margin_bottom = global_position.y+7


func pickable():
	return true


func pick(player_number):
	if not bought:
		PlayerStats.spend_money(player_number, 1)
		bought = true


func place(place: Place):
	assert(place)
	if place.target.is_empty():
		count -= 1
		$Label.text = str(count)
		var planted = preload("res://scenes/objects/plant_planted.tscn").instance()
		planted.plant_type = plant_type
		place.target.add_child(planted)
		planted.position = Vector2(0, 16)
		planted.get_node("AsepriteSprite/AnimationPlayer").play("Grow1")
		var collider = preload("res://scenes/objects/planted_plant_collider.tscn").instance()
		planted.add_child(collider)
		collider.name = "Collider"
		planted.name = "Planted"

		if count == 0:
			queue_free()

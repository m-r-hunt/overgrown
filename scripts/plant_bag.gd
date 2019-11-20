extends Area2D


class_name Plant


enum PlantType {
	CARROT,
	TOMATO
	MAX,
}


export var plant_type := PlantType.CARROT
export var count := 9


func _ready():
	var sprite
	match plant_type:
		PlantType.CARROT:
			sprite = preload("res://sprites/carrot.json").instance()
		PlantType.TOMATO:
			sprite = preload("res://sprites/tomato.json").instance()
	sprite.name = "AsepriteSprite"
	add_child(sprite)
	$Label.text = str(count)
	$Label.set_as_toplevel(true)


func _process(_delta):
	$Label.margin_left = global_position.x-1
	$Label.margin_right = global_position.x+7
	$Label.margin_top = global_position.y-7
	$Label.margin_bottom = global_position.y+7


func pickable():
	return true


func place(place: Place):
	assert(place)
	if place.target.is_empty():
		count -= 1
		$Label.text = str(count)
		var planted = preload("res://scenes/objects/plant_planted.tscn").instance()
		planted.plant_type = plant_type
		place.target.add_child(planted)
		planted.position = Vector2.ZERO
		planted.get_node("AsepriteSprite/AnimationPlayer").play("Grow1")
		var collider = preload("res://scenes/objects/carrot_collider.tscn").instance()
		planted.add_child(collider)
		collider.name = "CarrotCollider"
		planted.name = "Planted"

		if count == 0:
			queue_free()

extends Node2D


var seeds_in_stock := 0
var seed_base_pos := Vector2(-24, 48)


func _ready():
	restock()


func restock():
	for i in range(4):
		var seeds = preload("res://scenes/objects/plant_bag.tscn").instance()
		seeds.position = seed_base_pos + Vector2(i*16, 0)
		seeds.randomise_type()
		add_child(seeds)
	seeds_in_stock = 4
	$AsepriteSprite/AnimationPlayer.play("Idle")


func reset_after_pick():
	seeds_in_stock -= 1
	if seeds_in_stock <= 0:
		$AsepriteSprite/AnimationPlayer.play("Shut")
		yield(get_tree().create_timer(5.0), "timeout")
		restock()

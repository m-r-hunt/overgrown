extends Node2D


var seeds_in_stock := 0
var seed_base_pos := Vector2(-24, 48)


func _ready():
	restock()


func restock():
	for i in range(4):
		var seeds := preload("res://scenes/objects/plant_bag.tscn").instance()
		seeds.position = seed_base_pos + Vector2(i*16, 0)
		seeds.plant_type = PlantManager.random_plant()
		add_child_below_node($TruckSprite, seeds)
		get_node("PlantSign" + str(i+1)).plant = seeds.plant_type
	seeds_in_stock = 4
	$TruckSprite/AnimationPlayer.play("Idle")
	$DoorSprite/AnimationPlayer.play("Idle")


func reset_after_pick():
	seeds_in_stock -= 1
	if seeds_in_stock <= 0:
		$TruckSprite/AnimationPlayer.play("Shut")
		$DoorSprite/AnimationPlayer.play("Shut")
		yield(get_tree().create_timer(5.0), "timeout")
		restock()

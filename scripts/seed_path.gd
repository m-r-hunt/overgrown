extends Path2D

func _ready():
	Utils.e_connect($Timer, "timeout", self, "on_timeout")
	

func on_timeout():
	$Timer.wait_time = rand_range(1.0, 5.0)
	var new_seed_type = floor(rand_range(0.0, Plant.PlantType.MAX))
	var new_seed = preload("res://scenes/objects/plant.tscn").instance()
	new_seed.plant_type = int(new_seed_type)
	var follower = preload("res://scripts/seed_carrier.gd").new()
	follower.rotate = false
	follower.rotation = rotation
	follower.add_child(new_seed)
	add_child(follower)

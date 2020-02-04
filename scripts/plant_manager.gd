extends Node


var plant_resources := []

const plant_resource_dir = "res://plants/"

func _ready():
	var dir := Directory.new()
	Utils.assert_ok(dir.open(plant_resource_dir))
	Utils.assert_ok(dir.list_dir_begin(true))
	var file_name := dir.get_next()
	while file_name != "":
		plant_resources.append(load(plant_resource_dir + file_name))
		file_name = dir.get_next()


func random_plant() -> PlantResource:
	return plant_resources[randi() % len(plant_resources)]

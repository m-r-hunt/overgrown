extends Node2D


var plant: PlantResource setget set_plant


func set_plant(p):
	plant = p
	$TimeNumber.frame = floor(plant.growth_time / 2.0) - 1
	$CostNumber.frame = plant.sell_price - 1

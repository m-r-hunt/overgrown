extends Area2D


export var multiplier := 2
var wanted_product: PlantResource


signal bought                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  


func sell_multiplier(plant: PlantResource) -> int:
	if plant == wanted_product:
		emit_signal("bought")
		return multiplier
	else:
		return 0

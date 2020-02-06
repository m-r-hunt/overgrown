extends Area2D


export var multiplier := 2
var wanted_product: PlantResource


signal bought
signal buy_rejected


func sell_multiplier(plant: PlantResource) -> int:
	if plant == wanted_product:
		emit_signal("bought")
		return multiplier
	else:
		emit_signal("buy_rejected")
		return 0

extends Area2D


export var multiplier := 2
var wanted_product: PlantResource
var bought := false


signal bought
signal buy_rejected


func sell_multiplier(plant: PlantResource) -> int:
	if plant == wanted_product and not bought:
		bought = true
		emit_signal("bought")
		return multiplier
	else:
		emit_signal("buy_rejected")
		return 0

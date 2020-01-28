extends Area2D


export var multiplier := 2
var wanted_product


func sell_multiplier(plant):
	if plant == wanted_product:
		get_parent().queue_free()
		return multiplier
	else:
		return 0

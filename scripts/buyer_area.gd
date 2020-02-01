extends Area2D


export var multiplier := 2
var wanted_product

signal bought                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  


func sell_multiplier(plant):
	if plant == wanted_product:
		emit_signal("bought")
		return multiplier
	else:
		return 0

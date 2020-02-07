extends Area2D


var water_level := WATER_MAX

const WATER_MAX = 5


func pickable(_player_number: int) -> bool:
	return true


func _ready():
	update_water_meter()


func update_water_meter():
	$ColorRect.margin_right = -7 + 14 * water_level / float(WATER_MAX)


func place(place: Place):
	assert(place)
	if place.target.has_method("water"):
		if water_level > 0:
			var watered: bool = place.target.water()
			if watered:
				water_level -= 1
				update_water_meter()
		else:
			# TODO Feedback on no water
			pass
	elif place.target.has_method("refill_water"):
		water_level = WATER_MAX
		place.target.refill_water()
		update_water_meter()

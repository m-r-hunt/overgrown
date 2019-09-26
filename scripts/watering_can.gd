extends Area2D


func pickable():
	return true


func place(place: Place):
	assert(place)
	if place.target.has_method("water"):
		place.target.water()


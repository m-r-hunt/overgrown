extends Node2D

export var pixel_scale := 1


func _ready():
	window_resize()
	Utils.e_connect(get_viewport(), "size_changed", self, "window_resize")

func window_resize():
	get_viewport().set_size_override(true, OS.get_window_size() / pixel_scale)

extends Node2D


export var pixel_scale := 1


func _ready():
	window_resize()
	Utils.e_connect(get_viewport(), "size_changed", self, "window_resize")
	


func _process(_delta):
	if Input.is_action_just_pressed("scale_up"):
		pixel_scale += 1
		window_resize()
	if Input.is_action_just_pressed("scale_down") && pixel_scale >= 2:
		pixel_scale -= 1
		window_resize()


func window_resize():
	assert(pixel_scale > 0 && typeof(pixel_scale) == TYPE_INT)
	get_viewport().set_size_override(true, OS.get_window_size() / pixel_scale)

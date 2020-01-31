extends Node2D

# This script applies pixel perfect scaling at the maximum possible size fitting the width/height from project settings on screen.
# Also centers that area of the screen in the view.


export var pixel_scale := 1
onready var viewport = get_viewport()
onready var width = ProjectSettings.get_setting("display/window/size/width")
onready var height = ProjectSettings.get_setting("display/window/size/height")


func _ready():
	window_resize()
	Utils.e_connect(viewport, "size_changed", self, "window_resize")


func _process(_delta):
	var window_size = OS.window_size;
	var scale = 1;
	while width*scale <= window_size.x and height*scale <= window_size.y:
		scale += 1
	scale -= 1
	if scale != pixel_scale:
		pixel_scale = int(max(1, scale))
		print("Pixel scaling: " + str(pixel_scale))
	# Resize (set global_canvas_transform) every frame. Seems to be necessary as Windows release is weird
	window_resize()



func window_resize():
	assert(pixel_scale > 0 && typeof(pixel_scale) == TYPE_INT)
	#var x_diff = OS.window_size.x - width*pixel_scale
	#var y_diff = OS.window_size.y - height*pixel_scale
	#viewport.global_canvas_transform = Transform2D(0, Vector2(floor(x_diff/(2*pixel_scale)), floor(y_diff/(2*pixel_scale)))).scaled(Vector2(pixel_scale, pixel_scale))

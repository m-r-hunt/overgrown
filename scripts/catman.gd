extends KinematicBody2D

var player_speed := 100.0
var last_select_dir := Vector2(0, 1)

var down_action := "p1_down"
var up_action := "p1_up"
var left_action := "p1_left"
var right_action := "p1_right"

func _ready():
	$"Aseprite Sprite/Animation Player".play("Walk")


func _physics_process(delta):
	var dx = Vector2()
	if Input.is_action_pressed(down_action):
		dx.y = 1
	if Input.is_action_pressed(up_action):
		dx.y = -1
	if Input.is_action_pressed(left_action):
		dx.x = -1
	if Input.is_action_pressed(right_action):
		dx.x = 1
	if dx != Vector2(0, 0):
		last_select_dir = dx
	dx *= player_speed * delta
	Utils.use(move_and_collide(dx))
	var selector_x = 8 + floor(global_position.x / 16)*16 + last_select_dir.x * 16
	var selector_y = 8 + floor(global_position.y / 16)*16 + last_select_dir.y * 16
	$"Selector".position = Vector2(selector_x, selector_y) - global_position

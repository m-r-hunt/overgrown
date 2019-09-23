extends KinematicBody2D

var player_speed := 100.0
var last_select_dir := Vector2(0, 1)

export var down_action := "p1_down"
export var up_action := "p1_up"
export var left_action := "p1_left"
export var right_action := "p1_right"
export var interact_action := "p1_interact"

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
	if Input.is_action_just_pressed(interact_action):
		if has_node("Held"):
			var obj = get_node("Held")
			obj.position = $Selector.global_position - get_parent().position
			remove_child(obj)
			get_parent().add_child(obj)
		else:
			var collider = $Selector/RayCast2D.get_collider()
			if collider:
				var obj = collider.get_parent()
				if obj.has_method("pickable") && obj.pickable():
					obj.get_parent().remove_child(obj)
					add_child(obj)
					obj.position = Vector2(0.0, -32.0)
					obj.name = "Held"

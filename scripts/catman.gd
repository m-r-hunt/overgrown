extends KinematicBody2D


var player_speed := 100.0
var last_select_dir := Vector2(0, 1)


export var down_action := "p1_down"
export var up_action := "p1_up"
export var left_action := "p1_left"
export var right_action := "p1_right"
export var interact_action := "p1_interact"


func _ready():
	$AsepriteSprite/AnimationPlayer.play("Walk")


func _physics_process(_delta):
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
	dx *= player_speed
	Utils.use(move_and_slide(dx))

	var selector_x = 8 + floor(global_position.x / 16)*16 + last_select_dir.x * 16
	var selector_y = 8 + floor(global_position.y / 16)*16 + last_select_dir.y * 16
	$"Selector".position = Vector2(selector_x, selector_y) - global_position

	if Input.is_action_just_pressed(interact_action):
		if has_node("Held"):
			var plot_areas = $Selector/PlotArea.get_overlapping_areas()
			var seller_areas = $Selector/SellerArea.get_overlapping_areas()
			if len(plot_areas) > 0:
				var obj = plot_areas[0]
				if $Held.has_method("place"):
					print("Placing", $Held, "on", obj)
					$Held.place(Place.new(obj))
			elif len(seller_areas) > 0:
				var obj = seller_areas[0]
				if $Held.has_method("sell"):
					print("Selling", $Held, "at", obj)
					$Held.sell(Sell.new(obj, get_parent()))
			else:
				var areas = $Selector/PickableArea.get_overlapping_areas()
				if len(areas) == 0:
					var obj = get_node("Held")
					obj.position = $Selector.global_position - get_parent().global_position
					remove_child(obj)
					get_parent().add_child(obj)
		else:
			var areas = $Selector/PickableArea.get_overlapping_areas()
			if len(areas) > 0:
				var obj = areas[0]
				if obj.has_method("pickable") && obj.pickable():
					var old_parent = obj.get_parent()
					old_parent.remove_child(obj)
					if old_parent.has_method("reset_after_pick"):
						old_parent.reset_after_pick()
					add_child(obj)
					obj.position = Vector2(0.0, -32.0)
					obj.name = "Held"

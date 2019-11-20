extends KinematicBody2D


enum STATE {
	NORMAL,
	HOLDING
	DASHING,
	BASHED,
}

var state = STATE.NORMAL

var last_select_dir := Vector2(0, 1)
var held_obj = null
var hold_time = 0
var selector_pos = Vector2(0, 0)
var dash_time = 0

const player_speed := 100.0
const DASH_LENGTH := 0.33
const DASH_SPEED := 200.0


export var down_action := "p1_down"
export var up_action := "p1_up"
export var left_action := "p1_left"
export var right_action := "p1_right"
export var interact_action := "p1_interact"
export var dash_action := "p1_dash"


func _ready():
	$AsepriteSprite/AnimationPlayer.play("Walk")


func _physics_process(delta):
	match state:
		STATE.NORMAL:
			update_normal()
		STATE.HOLDING:
			update_holding(delta)
		STATE.DASHING:
			update_dashing(delta)
		STATE.BASHED:
			update_bashed(delta)


func process_movement():
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


func process_selector(update_position: bool):
	if update_position:
		var selector_x = 8 + floor($CollisionShape2D.global_position.x / 16)*16 + last_select_dir.x * 16
		var selector_y = 8 + floor($CollisionShape2D.global_position.y / 16)*16 + last_select_dir.y * 16
		selector_pos = Vector2(selector_x, selector_y)
	$"Selector".position = selector_pos - global_position


func update_normal():
	process_movement()
	process_selector(true)
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
				else:
					state = STATE.HOLDING
					held_obj = obj
					hold_time = 0
	if Input.is_action_just_pressed(dash_action):
		state = STATE.DASHING
		dash_time = 0.0


func update_holding(delta):
	process_movement()
	process_selector(false)
	if !is_instance_valid(held_obj):
		print("Cancelling hold")
		state = STATE.NORMAL
	if !Input.is_action_pressed(interact_action):
		state = STATE.NORMAL
	else:
		hold_time += delta
		if hold_time >= 1.0:
			if held_obj.has_method("hold_interact"):
				held_obj.hold_interact()
			state = STATE.NORMAL


func update_dashing(delta):
	process_selector(true)
	dash_time += delta
	if dash_time >= DASH_LENGTH:
		state = STATE.NORMAL
	var dx = last_select_dir * DASH_SPEED
	var coll = move_and_collide(dx*delta)
	if coll:
		bash()
		if coll.collider.has_method("bash"):
			coll.collider.bash()


func update_bashed(delta):
	dash_time += delta
	if dash_time >= DASH_LENGTH:
		state = STATE.NORMAL


func bash():
	state = STATE.BASHED
	var areas = $Selector/PickableArea.get_overlapping_areas()
	if len(areas) == 0:
		var obj = get_node("Held")
		obj.position = $Selector.global_position - get_parent().global_position
		remove_child(obj)
		get_parent().add_child(obj)

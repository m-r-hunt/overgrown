extends KinematicBody2D


enum STATE {
	NORMAL,
	HOLDING
	DASHING,
	BASHED,
}


const player_speed := 100.0
const DASH_LENGTH := 0.33
const DASH_SPEED := 200.0


export(int, 1, 4) var player_number := 1 setget set_player_number

export var down_action := "p1_down"
export var up_action := "p1_up"
export var left_action := "p1_left"
export var right_action := "p1_right"
export var interact_action := "p1_interact"
export var dash_action := "p1_dash"


var state: int = STATE.NORMAL
var last_select_dir := Vector2(0, 1)
var held_obj: Node = null # Holding interact on to destroy
var hold_time := 0.0
var selector_pos := Vector2(0, 0)
var dash_time := 0.0


func _ready():
	$AsepriteSprite/AnimationPlayer.play("Idle")
	set_player_number(player_number)

func set_player_number(n: int):
	collision_layer &= ~(1 << player_number)
	player_number = n
	collision_layer |= (1 << player_number)
	up_action = str("p", player_number, "_up")
	down_action = str("p", player_number, "_down")
	left_action = str("p", player_number, "_left")
	right_action = str("p", player_number, "_right")
	interact_action = str("p", player_number, "_interact")
	dash_action = str("p", player_number, "_dash")
	$AsepriteSprite.texture = load(str("res://sprites/catman", player_number, ".png"))

func _physics_process(delta: float):
	match state:
		STATE.NORMAL:
			update_normal()
		STATE.HOLDING:
			update_holding(delta)
		STATE.DASHING:
			update_dashing(delta)
		STATE.BASHED:
			update_bashed(delta)
		_:
			assert(false)


func process_movement():
	var dx := Vector2()
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

	if dx.y == 1:
		$AsepriteSprite/AnimationPlayer.play("WalkDown")
	elif dx.y == -1:
		$AsepriteSprite/AnimationPlayer.play("WalkUp")
	elif dx.x == -1:
		$AsepriteSprite/AnimationPlayer.play("WalkLeft")
	elif dx.x == 1:
		$AsepriteSprite/AnimationPlayer.play("WalkRight")
	else:
		$AsepriteSprite/AnimationPlayer.play("Idle")

	dx *= player_speed
	Utils.use(move_and_slide(dx))

func process_selector(update_position: bool):
	if update_position:
		var selector_x := 8 + floor($CollisionShape2D.global_position.x / 16)*16 + last_select_dir.x * 16
		var selector_y := 8 + floor($CollisionShape2D.global_position.y / 16)*16 + last_select_dir.y * 16
		selector_pos = Vector2(selector_x, selector_y)
	$Selector.position = selector_pos - global_position


func update_normal():
	process_movement()
	process_selector(true)
	
	if Input.is_action_just_pressed(interact_action):
		interact()
	if Input.is_action_just_pressed(dash_action):
		state = STATE.DASHING
		dash_time = 0.0


func interact():
	if has_node("Held"):
		try_place()
	else:
		try_pick()


func try_place():
	var plot_detector := $Selector/PlotArea as Area2D
	var seller_detector := $Selector/SellerArea as Area2D
	var plot_areas := plot_detector.get_overlapping_areas()
	var seller_areas := seller_detector.get_overlapping_areas()
	if len(plot_areas) > 0:
		var obj = plot_areas[0]
		if $Held.has_method("place"):
			print("Placing", $Held, "on", obj)
			$Held.place(Place.new(obj))
	elif len(seller_areas) > 0:
		var obj = seller_areas[0]
		if $Held.has_method("sell"):
			print("Selling", $Held, "at", obj)
			$Held.sell(Sell.new(obj, self))
	else:
		var pickable_detector := $Selector/PickableArea as Area2D
		var placement_detector := $Selector/PlacementArea as Area2D
		if len(placement_detector.get_overlapping_areas()) == 0:
			return
		var areas := pickable_detector.get_overlapping_areas()
		if len(areas) == 0:
			var obj := get_node("Held")
			obj.position = $Selector.global_position - get_parent().global_position + Vector2(0, 8)
			remove_child(obj)
			get_parent().add_child(obj)


func try_pick():
	var pickable_detector := $Selector/PickableArea as Area2D
	var areas := pickable_detector.get_overlapping_areas()
	if len(areas) > 0:
		var obj := areas[0] as Node2D
		if obj.has_method("pickable") && obj.pickable(player_number):
			var old_parent := obj.get_parent()
			old_parent.remove_child(obj)
			if old_parent.has_method("reset_after_pick"):
				old_parent.reset_after_pick()
			add_child(obj)
			obj.position = Vector2(0.0, -32.0)
			obj.name = "Held"
			if obj.has_method("pick"):
				obj.pick(player_number)
		else:
			state = STATE.HOLDING
			held_obj = obj
			hold_time = 0


func update_holding(delta: float):
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


func update_dashing(delta: float):
	process_selector(true)
	dash_time += delta
	if dash_time >= DASH_LENGTH:
		state = STATE.NORMAL
	var dx = last_select_dir * DASH_SPEED
	var coll = move_and_collide(dx*delta)
	if coll:
		bash(dash_time)
		if coll.collider.has_method("bash"):
			coll.collider.bash(dash_time)


func update_bashed(delta: float):
	dash_time += delta
	if dash_time >= DASH_LENGTH:
		state = STATE.NORMAL


func bash(t: float):
	dash_time = t
	state = STATE.BASHED

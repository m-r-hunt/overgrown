extends Node2D


enum CONTROL_TYPE {
	UNSET,
	KEYBOARD,
	JOY1,
	JOY2,
	JOY3,
	JOY4,
}

func key_press(key):
	var ev = InputEventKey.new()
	ev.scancode = key
	ev.pressed = true
	return ev

func joy_press(device, button):
	var ev = InputEventJoypadButton.new()
	ev.device = device
	ev.button_index = button
	ev.pressed = true
	return ev
	
func joy_axis(device, axis, value): # value = +-1 for direction
	var ev = InputEventJoypadMotion.new()
	ev.device = device
	ev.axis = axis
	ev.axis_value = value
	return ev

const events := ["p%s_left", "p%s_right", "p%s_up", "p%s_down", "p%s_interact", "p%s_dash"]
var inputs := {
	CONTROL_TYPE.KEYBOARD: {
		"p%s_left": [key_press(KEY_A), key_press(KEY_LEFT)], 
		"p%s_right": [key_press(KEY_D), key_press(KEY_RIGHT)], 
		"p%s_up": [key_press(KEY_W), key_press(KEY_UP)], 
		"p%s_down": [key_press(KEY_S), key_press(KEY_DOWN)], 
		"p%s_interact": [key_press(KEY_J)],
		"p%s_dash": [key_press(KEY_K)],
	},
	CONTROL_TYPE.JOY1: {
		"p%s_left": [joy_press(0, JOY_DPAD_LEFT), joy_axis(0, JOY_AXIS_0, -1)], 
		"p%s_right": [joy_press(0, JOY_DPAD_RIGHT), joy_axis(0, JOY_AXIS_0, 1)], 
		"p%s_up": [joy_press(0, JOY_DPAD_UP), joy_axis(0, JOY_AXIS_1, -1)], 
		"p%s_down": [joy_press(0, JOY_DPAD_DOWN), joy_axis(0, JOY_AXIS_1, 1)], 
		"p%s_interact": [joy_press(0, JOY_XBOX_A)],
		"p%s_dash": [joy_press(0, JOY_XBOX_B)],
	},
	CONTROL_TYPE.JOY2: {
		"p%s_left": [joy_press(1, JOY_DPAD_LEFT), joy_axis(1, JOY_AXIS_0, -1)], 
		"p%s_right": [joy_press(1, JOY_DPAD_RIGHT), joy_axis(1, JOY_AXIS_0, 1)], 
		"p%s_up": [joy_press(1, JOY_DPAD_UP), joy_axis(1, JOY_AXIS_1, -1)], 
		"p%s_down": [joy_press(1, JOY_DPAD_DOWN), joy_axis(1, JOY_AXIS_1, 1)], 
		"p%s_interact": [joy_press(1, JOY_XBOX_A)],
		"p%s_dash": [joy_press(1, JOY_XBOX_B)],
	},
	CONTROL_TYPE.JOY3: {
		"p%s_left": [joy_press(2, JOY_DPAD_LEFT), joy_axis(2, JOY_AXIS_0, -1)], 
		"p%s_right": [joy_press(2, JOY_DPAD_RIGHT), joy_axis(2, JOY_AXIS_0, 1)], 
		"p%s_up": [joy_press(2, JOY_DPAD_UP), joy_axis(2, JOY_AXIS_1, -1)], 
		"p%s_down": [joy_press(2, JOY_DPAD_DOWN), joy_axis(2, JOY_AXIS_1, 1)], 
		"p%s_interact": [joy_press(2, JOY_XBOX_A)],
		"p%s_dash": [joy_press(2, JOY_XBOX_B)],
	},
	CONTROL_TYPE.JOY4: {
		"p%s_left": [joy_press(3, JOY_DPAD_LEFT), joy_axis(3, JOY_AXIS_0, -1)], 
		"p%s_right": [joy_press(3, JOY_DPAD_RIGHT), joy_axis(3, JOY_AXIS_0, 1)], 
		"p%s_up": [joy_press(3, JOY_DPAD_UP), joy_axis(3, JOY_AXIS_1, -1)], 
		"p%s_down": [joy_press(3, JOY_DPAD_DOWN), joy_axis(3, JOY_AXIS_1, 1)], 
		"p%s_interact": [joy_press(3, JOY_XBOX_A)],
		"p%s_dash": [joy_press(3, JOY_XBOX_B)],
	},
}

var players := [CONTROL_TYPE.UNSET, CONTROL_TYPE.UNSET, CONTROL_TYPE.UNSET, CONTROL_TYPE.UNSET]


func _ready():
	Utils.e_connect(Input, "joy_connection_changed", self, "on_joy_connection_changed")
	Utils.e_connect($ConnectionPopup/Timer, "timeout", self, "on_timeout")
	Utils.e_connect($StartButton, "pressed", self, "on_start_pressed")


func control_type_string(ct):
	match ct:
		CONTROL_TYPE.UNSET: return "UNSET"
		CONTROL_TYPE.KEYBOARD: return "KEYBOARD"
		CONTROL_TYPE.JOY1: return "JOY1"
		CONTROL_TYPE.JOY2: return "JOY2"
		CONTROL_TYPE.JOY3: return "JOY3"
		CONTROL_TYPE.JOY4: return "JOY4"


func assign_player(control_type):
	for i in range(0, 4):
		if players[i] == CONTROL_TYPE.UNSET:
			players[i] = control_type
			print(control_type_string(control_type), " assigned player ", i)
			get_node("P"+str(i+1)+"Label").text = "Player " + str(i+1) + ": " + control_type_string(control_type)
			return


func remove_player(control_type):
	for i in range(0, 4):
		if players[i] == control_type:
			players[i] = CONTROL_TYPE.UNSET
			print("Remove ", control_type_string(control_type), " from player ", i)
			get_node("P"+str(i+1)+"Label").text = "Player " + str(i+1) + ": " + "Press any key"


func _input(event):
	if event is InputEventKey:
		if event.scancode == KEY_ESCAPE:
			if CONTROL_TYPE.KEYBOARD in players:
				remove_player(CONTROL_TYPE.KEYBOARD)
		else:
			if not CONTROL_TYPE.KEYBOARD in players:
				assign_player(CONTROL_TYPE.KEYBOARD)
	elif event is InputEventJoypadButton:
		var ct = CONTROL_TYPE.JOY1+event.device
		if event.button_index == JOY_SELECT:
			if ct in players:
				remove_player(ct)
		else:
			if not ct in players:
				assign_player(ct)


func on_joy_connection_changed(device, connected):
	var ct = CONTROL_TYPE.JOY1+device
	if not connected and ct in players:
		remove_player(ct)
	
	if connected:
		$ConnectionPopup.text = "Controller " + str(device + 1) + " connected"
	else:
		$ConnectionPopup.text = "Controller " + str(device + 1) + " disconnected"
	$ConnectionPopup/Timer.start()


func on_timeout():
	$ConnectionPopup.text = ""


func active_players():
	var total = 0
	for p in players:
		if p != CONTROL_TYPE.UNSET:
			total += 1
	return total


func on_start_pressed():
	if active_players() < 2:
		$ConnectionPopup.text = "Need at least 2 players"
		$ConnectionPopup/Timer.start()
		return
	var farms = preload("res://scenes/screens/farms.tscn").instance()
	for i in range(0, len(players)):
		var ct = players[i]
		if ct == CONTROL_TYPE.UNSET:
			farms.remove_player(i)
			PlayerStats.active_players[i] = false
		else:
			PlayerStats.active_players[i] = true
	get_parent().add_child(farms)
	
	for i in range(0, len(players)):
		for ev in events:
			InputMap.action_erase_events(ev % (i+1))
		if players[i] != CONTROL_TYPE.UNSET:
			for ev in events:
				for input in inputs[players[i]][ev]:
					InputMap.action_add_event(ev % (i+1), input)
			
	
	get_parent().remove_child(self)

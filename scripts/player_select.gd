extends Node2D


enum CONTROL_TYPE {
	UNSET,
	KEYBOARD,
	JOY1,
	JOY2,
	JOY3,
	JOY4,
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
	var farms = preload("res://scenes/farms.tscn").instance()
	for i in range(0, len(players)):
		var ct = players[i]
		if ct == CONTROL_TYPE.UNSET:
			farms.remove_player(i)
	get_parent().add_child(farms)
	get_parent().remove_child(self)

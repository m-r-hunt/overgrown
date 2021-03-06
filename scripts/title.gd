extends Node2D


func _ready():
	Utils.e_connect($PlayButton, "pressed", self, "on_play_button_pressed")
	Utils.e_connect($QuitButton, "pressed", self, "on_quit_button_pressed")


func _process(_delta: float):
	if Input.is_action_just_pressed("ui_accept"):
		play()
	elif Input.is_action_just_pressed("ui_cancel"):
		quit()


func on_play_button_pressed():
	play()


func on_quit_button_pressed():
	quit()


func play():
	Utils.assert_ok(get_tree().change_scene("res://scenes/screens/player_select.tscn"))


func quit():
	get_tree().quit()

extends Node


func _ready():
	if ProjectSettings.get_setting("my_settings/auto_full_screen"):
		OS.window_maximized = true

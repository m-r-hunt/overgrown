extends Node


func _ready():
	if ProjectSettings.get_setting("my_settings/auto_maximize"):
		OS.window_maximized = true

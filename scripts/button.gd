extends TextureButton

tool

export var text := "" setget set_text

func set_text(t):
	text = t
	$Label.text = t
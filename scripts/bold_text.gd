extends Label
tool

export var bold_text := "" setget set_text
export(Font) var custom_font = null setget set_theme

func set_text(val):
	bold_text = val
	text = val
	$Outline1.text = val
	$Outline2.text = val
	$Outline3.text = val
	$Outline4.text = val


func set_theme(t):
	custom_font = t
	font = t
	$Outline1.font = t
	$Outline2.font = t
	$Outline3.font = t
	$Outline4.font = t

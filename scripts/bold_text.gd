extends Label

tool


export var bold_text := "" setget set_text
export(Font) var custom_font := preload("res://m5x7.tres") as Font setget set_font


var ready := false


func _ready():
	ready = true
	set_text(bold_text)
	set_font(custom_font)


func set_text(val: String):
	bold_text = val
	text = val
	if ready:
		$Outline1.text = val
		$Outline2.text = val
		$Outline3.text = val
		$Outline4.text = val


func set_font(t: Font):
	custom_font = t
	add_font_override("font", custom_font)
	if ready:
		$Outline1.add_font_override("font", t)
		$Outline2.add_font_override("font", t)
		$Outline3.add_font_override("font", t)
		$Outline4.add_font_override("font", t)

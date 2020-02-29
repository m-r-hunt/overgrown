extends Node2D

tool


export var text := "" setget set_text


func set_text(t: String):
	text = t
	$Label.text = t

signal pressed

func _ready():
	Utils.e_connect($Button, "pressed", self, "on_pressed")

func on_pressed():
	emit_signal("pressed")

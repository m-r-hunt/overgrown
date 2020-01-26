extends KinematicBody2D


export var velocity := 20.0
onready var orig_y := position.y


func _physics_process(delta):
	position.x += velocity * delta
	position.y = orig_y

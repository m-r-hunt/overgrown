extends KinematicBody2D


export var velocity := 20.0
export var dir := 1.0
var spawned = null

onready var orig_y := position.y


func _ready():
	if dir < 0:
		$AsepriteSprite/AnimationPlayer.play("WalkLeft")

func _physics_process(delta: float):
	position.x += velocity * delta * dir
	position.y = orig_y

extends KinematicBody2D


var speed = 20.0
var wander_time = 0.0
var wander_direction = 0


func _ready():
	$AsepriteSprite/AnimationPlayer.play("WalkRight")
	var wanted_product = Plant.random_type()
	$Area2D.wanted_product = wanted_product
	var sprite = Plant.get_sprite(wanted_product)
	sprite.position = Vector2(0, -2)
	$SpeechBalloon.add_child(sprite)


func _physics_process(delta):
	wander_time -= delta
	if wander_time <= 0:
		wander_time = rand_range(1.0, 4.0)
		wander_direction = randi() % 4
	var vec = Vector2.ZERO
	match wander_direction:
		0:
			vec = Vector2(1, 0)
		1:
			vec = Vector2(0, 1)
		2:
			vec = Vector2(-1, 0)
		3:
			vec = Vector2(0, -1)
	vec *= speed * delta
	Utils.use(move_and_collide(vec))

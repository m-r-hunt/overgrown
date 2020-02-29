extends KinematicBody2D


var speed := 20.0
var wander_time := 0.0
var wander_direction := 0
# Hack todo remnove
var dir
var spawned


func _ready():
	$AsepriteSprite/AnimationPlayer.play("WalkRight")
	var wanted_product := PlantManager.random_plant()
	$Area2D.wanted_product = wanted_product
	var sprite := wanted_product.sprite.instance()
	sprite.position = Vector2(0, -2)
	$SpeechBalloon.add_child(sprite)
	sprite.get_node("AnimationPlayer").play("Item")
	Utils.e_connect($Area2D, "bought", self, "on_bought")
	Utils.e_connect($Area2D, "buy_rejected", self, "on_buy_rejected")


func _physics_process(delta: float):
	wander_time -= delta
	if wander_time <= 0:
		wander_time = rand_range(1.0, 4.0)
		wander_direction = randi() % 4
	var vec := Vector2.RIGHT.rotated(wander_direction * PI / 2.0)
	vec *= speed * delta
	Utils.use(move_and_collide(vec))


func on_bought():
	queue_free()


func on_buy_rejected():
	$SpeechBalloon/cross.visible = true
	$SpeechBalloon/AsepriteSprite.visible = false
	yield(get_tree().create_timer(1.0), "timeout")
	$SpeechBalloon/cross.visible = false
	$SpeechBalloon/AsepriteSprite.visible = true

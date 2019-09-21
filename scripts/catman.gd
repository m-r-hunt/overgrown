extends KinematicBody2D

var player_speed := 100.0


func _ready():
	$"Aseprite Sprite/Animation Player".play("Walk")


func _physics_process(delta):
	var dx = Vector2()
	if Input.is_action_pressed("p1_down"):
		dx.y = 1
	if Input.is_action_pressed("p1_up"):
		dx.y = -1
	if Input.is_action_pressed("p1_left"):
		dx.x = -1
	if Input.is_action_pressed("p1_right"):
		dx.x = 1
	dx *= player_speed * delta
	Utils.use(move_and_collide(dx))

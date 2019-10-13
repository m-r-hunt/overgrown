extends Area2D

export var speed := 10.0
export var direction := Vector2(0, 1)

func _physics_process(delta):
	for body in get_overlapping_bodies():
		body.move_and_collide(direction * delta * speed)

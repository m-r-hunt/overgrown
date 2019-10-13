extends PathFollow2D

export var speed = 10.0

func _physics_process(delta):
	offset += delta * speed
	if unit_offset >= 1.0:
		self.queue_free()

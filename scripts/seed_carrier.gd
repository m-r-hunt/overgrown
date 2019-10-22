extends PathFollow2D

export var speed = 20.0


func _ready():
	loop = false


func _physics_process(delta):
	offset += delta * speed
	if unit_offset >= 1.0:
		self.queue_free()

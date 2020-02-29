extends Node2D


export var max_spawn_time := 10.0
export var min_spawn_time := 2.0
export var dir := 1.0

var next_spawn_time := 0.0


func _ready():
	Utils.e_connect($Area2D, "body_entered", self, "on_body_entered")


func _process(delta: float):
	next_spawn_time -= delta
	if next_spawn_time < 0:
		var new_ped: Node2D = null
		if rand_range(0.0, 1.0) > 0.9:
			new_ped = preload("res://scenes/objects/buyer.tscn").instance()
		else:
			new_ped = preload("res://scenes/objects/pedestrian.tscn").instance()
		new_ped.position = position + Vector2(8, rand_range(-16, 16))
		new_ped.dir = dir
		new_ped.spawned = self
		get_parent().add_child(new_ped)
		next_spawn_time = rand_range(min_spawn_time, max_spawn_time)


func on_body_entered(body: Node):
	if body.spawned == self:
		body.queue_free()

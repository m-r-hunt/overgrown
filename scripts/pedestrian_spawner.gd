extends Node2D

export var max_spawn_time := 10.0
export var min_spawn_time := 2.0

var next_spawn_time := 0.0


func _ready():
	Utils.e_connect($Area2D, "body_entered", self, "on_body_entered")


func _process(delta):
	next_spawn_time -= delta
	if next_spawn_time < 0:
		var new_ped = null
		if rand_range(0.0, 1.0) > 0.9:
			new_ped = preload("res://scenes/objects/buyer.tscn").instance()
		else:
			new_ped = preload("res://scenes/objects/pedestrian.tscn").instance()
		new_ped.position = Vector2(8, rand_range(-16, 16))
		add_child(new_ped)
		next_spawn_time = rand_range(min_spawn_time, max_spawn_time)


func on_body_entered(body):
	body.queue_free()

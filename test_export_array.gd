extends Node2D

export var arr = []

export var some_arr = [1, 2]

func _ready():
	some_arr.append(rand_range(0.0, 10.0))
	print(some_arr)
	print(arr)

extends Node2D

export var custom_resource: Resource
export var custom_resource_2: Resource
export var custom_resource_3: Resource

func _ready():
	print("===")
	print(custom_resource.foo)
	print(custom_resource.bar)
	print("2:")
	print(custom_resource_2.foo)
	print(custom_resource_2.bar)
	print("3:")
	print(custom_resource_3.foo)
	print(custom_resource_3.bar)

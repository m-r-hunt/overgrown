extends TileMap

# Attached to imported maps.
# Exposes/forwards properties we may want to change per-instance.


func _ready():
	for node in get_children():
		node.collision_layer = collision_layer
		node.collision_mask = collision_mask

extends TileMap


# TODO more global? Changing tile size is probably hard at this point.
const TILE_SIZE = 16
const HALF_TILE_SIZE = TILE_SIZE / 2

var object_layers = [
	"TopLeft",
	"TopRight",
	"BottomLeft",
	"BottomRight",
]


func gate_only(farm):
	get_node("Tile Layer 1/" + farm + "WateringCan").queue_free()
	get_node("Tile Layer 1/" + farm + "Catman").queue_free()
	get_node("Tile Layer 1/" + farm + "Flag").queue_free()
	get_node("Tile Layer 1/" + farm + "MoneySign").queue_free()


func _ready():
	set_player_number("TopLeft", 1)
	set_player_number("TopRight", 2)
	set_player_number("BottomLeft", 3)
	set_player_number("BottomRight", 4)
	
	place_plots(2, 9, 2, 5)
	place_plots(22, 29, 2, 5)
	place_plots(2, 9, 13, 16)
	place_plots(22, 29, 13, 16)
	
	for node in get_children():
		if node is TileMap:
			continue
		elif node.name in object_layers:
			for child in node.get_children():
				child.name = node.name + child.name
				node.remove_child(child)
				$"Tile Layer 1".add_child(child)
		else:
			remove_child(node)
			$"Tile Layer 1".add_child(node)


func place_plots(xmin, xmax, ymin, ymax):
	var plot_prefab = preload("res://scenes/objects/plot.tscn")
	var x = xmin*TILE_SIZE + HALF_TILE_SIZE
	while x <= xmax*TILE_SIZE + HALF_TILE_SIZE:
		var y = ymin*TILE_SIZE
		while y <= ymax*TILE_SIZE:
			var plot = plot_prefab.instance()
			plot.position = Vector2(x, y)
			$"Tile Layer 1".add_child(plot)
			y += 16
		x += 16


func set_player_number(farm, p):
	get_node(farm + "/Gate").allowed_player = p
	get_node(farm + "/Catman").player_number = p
	get_node(farm + "/MoneySign").player_number = p
	get_node(farm + "/Flag").player_number = p

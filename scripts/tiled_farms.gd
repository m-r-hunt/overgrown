extends TileMap


func gate_only(farm):
	get_node(farm + "/WateringCan").queue_free()
	get_node(farm + "/Catman").queue_free()
	get_node(farm + "/Flag").queue_free()
	get_node(farm + "/MoneySign").queue_free()


func _ready():
	set_player_number("TopLeft", 1)
	var plot_prefab = preload("res://scenes/objects/plot.tscn")
	var x = 48+8
	while x <= 168+8:
		var y = 48+8
		while y <= 104+8:
			var plot = plot_prefab.instance()
			plot.position = Vector2(x, y)
			plot.z_index = -1
			add_child(plot)
			y += 16
		x += 16
	


func set_player_number(farm, p):
	get_node(farm + "/Gate").allowed_player = p
	get_node(farm + "/Catman").player_number = p
	get_node(farm + "/MoneySign").player_number = p
	get_node(farm + "/Flag").player_number = p

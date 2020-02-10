extends Reference

static func run(tiled_layer, _tileset, tilewidth, tileheight, root):
	var plot_scene = load("res://scenes/objects/plot.tscn")
	var layer = Node2D.new()
	root.add_child(layer)
	layer.owner = root
	
	var idata = tiled_layer.process_csv()
	for x in range(0, tiled_layer.width):
		for y in range(0, tiled_layer.height):
			var tid = idata[y*tiled_layer.width + x]
			if tid != 0:
				var plot = plot_scene.instance()
				layer.add_child(plot)
				plot.owner = root
				# Budge over in x because of where the origin in plot.tscn is (due to ysort)
				plot.position = Vector2(x * tilewidth + tilewidth/2, y * tileheight)

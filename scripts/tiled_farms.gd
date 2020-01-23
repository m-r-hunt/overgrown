extends TileMap


func gate_only():
	$Plots.queue_free()
	$WateringCan.queue_free()
	$Catman.queue_free()
	$Flag.queue_free()
	$MoneySign.queue_free()


func _ready():
	set_player_number("TopLeft", 1)


func set_player_number(farm, p):
	get_node(farm + "/Gate").allowed_player = p
	get_node(farm + "/Catman").player_number = p
	get_node(farm + "/MoneySign").player_number = p
	get_node(farm + "/Flag").player_number = p

extends Sprite

export var player_number = 1

func _process(_delta):
	$Label.text = str($"/root/PlayerStats".player_moneys[player_number-1])

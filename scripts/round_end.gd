extends Node2D

var bar_height = 200

func _ready():
	# Test Data
	#PlayerStats.active_players = [true, true, true, true]
	#PlayerStats.player_moneys = [4, 20, 14, 20]
	
	var max_money := 0.0
	var winner = 0
	var tie = false
	for i in range(0, 4):
		if PlayerStats.player_moneys[i] > max_money:
			max_money = PlayerStats.player_moneys[i]
			winner = i
		elif max_money > 0 and PlayerStats.player_moneys[i] == max_money:
			tie = true
	
	for i in range(0, 4):
		if !PlayerStats.active_players[i]:
			get_node("catman" + str(i+1)).queue_free()
			get_node("Bar" + str(i+1)).queue_free()
		else:
			var catman_node = get_node("catman" + str(i+1))
			var fraction = PlayerStats.player_moneys[i] / max_money
			var target_height = fraction * bar_height
			$Tween.interpolate_property(
				catman_node, 
				"position:y", 
				null, catman_node.position.y - target_height,
				fraction*animation_time,
				Tween.TRANS_LINEAR, Tween.EASE_OUT
			)
			var bar_node = get_node("Bar" + str(i+1))
			$Tween.interpolate_property(
				bar_node, 
				"margin_top", 
				null, bar_node.margin_top - target_height,
				fraction*animation_time,
				Tween.TRANS_LINEAR, Tween.EASE_OUT
			)
	$Tween.start()
	yield($Tween, "tween_all_completed")

	for i in range(0, 4):
		if PlayerStats.active_players[i]:
			get_node("Money" + str(i+1)).text = "$" + str(PlayerStats.player_moneys[i])
	
	if not tie:
		$WinnerLabel.text = "Player " + str(winner+1) + " Wins!"
	else:
		$WinnerLabel.text = "It's a tie!"

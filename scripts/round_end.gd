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
			get_node("Money" + str(i+1)).text = "$" + str(PlayerStats.player_moneys[i])
			$Tween.interpolate_property(
				get_node("catman" + str(i+1)), 
				"position", 
				get_node("catman" + str(i+1)).position, get_node("catman" + str(i+1)).position + Vector2(0, -(PlayerStats.player_moneys[i] / max_money) * bar_height),
				3.0,
				Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
			)
			$Tween.interpolate_property(
				get_node("Bar" + str(i+1)), 
				"margin_top", 
				get_node("Bar" + str(i+1)).margin_top, get_node("Bar" + str(i+1)).margin_top -(PlayerStats.player_moneys[i] / max_money) * bar_height,
				3.0,
				Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
			)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	
	if not tie:
		$WinnerLabel.text = "Player " + str(winner+1) + " Wins!"
	else:
		$WinnerLabel.text = "It's a tie!"

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
			get_node("catman" + str(i+1)).position.y -= (PlayerStats.player_moneys[i] / max_money) * bar_height
			get_node("Bar" + str(i+1)).margin_top -= (PlayerStats.player_moneys[i] / max_money) * bar_height
			get_node("Money" + str(i+1)).text = "$" + str(PlayerStats.player_moneys[i])
	
	if not tie:
		$WinnerLabel.text = "Player " + str(winner+1) + " Wins!"
	else:
		$WinnerLabel.text = "It's a tie!"

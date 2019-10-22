extends Node2D


func remove_player(i):
	match i:
		0:
			$Farms/TopLeft.gate_only()
		1:
			$Farms/TopRight.gate_only()
		2:
			$Farms/BottomLeft.gate_only()
		3:
			$Farms/BottomRight.gate_only()

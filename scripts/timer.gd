extends Node2D


var main_sequence := false
var playing := -1
onready var original_position := ($AsepriteSprite as Node2D).position


func _ready():
	$AsepriteSprite.position = Vector2(240, 135) - position
	$AsepriteSprite/AnimationPlayer.get_animation("Idle").loop = false
	$AsepriteSprite/AnimationPlayer.play("Idle")
	Utils.e_connect(PlayerStats, "time_started", self, "on_time_started")
	Utils.e_connect(PlayerStats, "time_up", self, "on_time_up")


func _process(_delta: float):
	if main_sequence:
		var portion = PlayerStats.get_time_portion()
		var stage := 1
		if portion < 0.25:
			stage = 1
		elif portion >= 0.25 and portion < 0.5:
			stage = 2
		elif portion >= 0.5 and portion < 0.75:
			stage = 3
		else:
			stage = 4
		if stage != playing:
			$AsepriteSprite/AnimationPlayer.play("Stage" + str(stage))
			playing = stage


func on_time_started():
	$AsepriteSprite/AnimationPlayer.get_animation("Spin").loop = false
	$AsepriteSprite/AnimationPlayer.play("Spin")
	yield($AsepriteSprite/AnimationPlayer, "animation_finished")
	$AsepriteSprite/AnimationPlayer.get_animation("Fall").loop = false
	$AsepriteSprite/AnimationPlayer.play("Fall")
	yield($AsepriteSprite/AnimationPlayer, "animation_finished")
	main_sequence = true
	$Tween.interpolate_property($AsepriteSprite, "position", $AsepriteSprite.position, original_position, 0.5, Tween.TRANS_QUINT, Tween.EASE_OUT)
	$Tween.start()


func on_time_up():
	main_sequence = false
	$Tween.interpolate_property($AsepriteSprite, "position", $AsepriteSprite.position, Vector2(240, 135) - position, 0.5, Tween.TRANS_QUINT, Tween.EASE_OUT)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	$AsepriteSprite/AnimationPlayer.get_animation("Finish").loop = false
	$AsepriteSprite/AnimationPlayer.play("Finish")

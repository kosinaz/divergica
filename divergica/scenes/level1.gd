extends Node2D

var current_mushroom = 0
var notes = []
var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	for _i in range(4):
		notes.append(rng.randi_range(0, 3))
	for mushroom in $"Mushrooms".get_children():
		mushroom.hide()

func _start_round():
	$"PaintButton".show()
	$"FollowTimer".start()
	$"BrushAnimationPlayer".play("0to1")
	current_mushroom = -1

func _on_paint_button_pressed():
	if $"FollowTimer".time_left < 0.5 or current_mushroom == -1:
		$"Brush".get_node("Error").play()
		return
	var mushroom_name = $"Mushrooms".get_child(current_mushroom).name
	if mushroom_name.begins_with("Black"):
		$"Brush".get_node("Error").play()
		return
	$"Brush".get_child(notes[current_mushroom]).play()
	if mushroom_name.begins_with("Striped"):
		if $"Mushrooms".get_child(current_mushroom).get_node("AnimatedSprite").animation == "once":
			$"Mushrooms".get_child(current_mushroom).get_node("AnimatedSprite").play("twice")
		else:
			$"Mushrooms".get_child(current_mushroom).get_node("AnimatedSprite").play("once")
	if mushroom_name.begins_with("White"):
		$"Mushrooms".get_child(current_mushroom).get_node("AnimatedSprite").play("painted")

func _on_lead_timer_timeout():
	if current_mushroom > 3:
		$"LeadTimer".stop()
		_start_round()
		return
	if not $"Mushrooms".get_child(current_mushroom).name.begins_with("None"):
		$"MushroomSounds".get_child(notes[current_mushroom]).play()
		$"Mushrooms".get_child(current_mushroom).get_node("AnimationPlayer").play("default")
	current_mushroom += 1

func _on_follow_timer_timeout():
	current_mushroom += 1
	if current_mushroom == 0:
		$"BrushAnimationPlayer".play("1to2")
	if current_mushroom == 1:
		$"BrushAnimationPlayer".play("2to3")
	if current_mushroom == 2:
		$"BrushAnimationPlayer".play("3to4")
	if current_mushroom > 3:
		$"FollowTimer".stop()
		$"PaintButton".hide()

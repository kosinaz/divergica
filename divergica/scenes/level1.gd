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
	$"BrushAnimationPlayer".play("0to1")
	current_mushroom = 0

func _on_paint_button_pressed():
	if current_mushroom > 3:
		return
	var mushroom_name = $"Mushrooms".get_child(current_mushroom).name
	if mushroom_name.begins_with("Black"):
		$"Brush".get_node("Error").play()
		current_mushroom += 1
		return
	$"Brush".get_child(notes[current_mushroom]).play()
	if mushroom_name.begins_with("Striped"):
		print($"Mushrooms".get_child(current_mushroom).get_node("AnimatedSprite").animation)
		if $"Mushrooms".get_child(current_mushroom).get_node("AnimatedSprite").animation == "once":
			print("yes")
			$"Mushrooms".get_child(current_mushroom).get_node("AnimatedSprite").play("twice")
			current_mushroom += 2
		else:
			$"Mushrooms".get_child(current_mushroom).get_node("AnimatedSprite").play("once")
	if mushroom_name.begins_with("White"):
		$"Mushrooms".get_child(current_mushroom).get_node("AnimatedSprite").play("painted")
		current_mushroom += 1
	print(current_mushroom)

func _on_timer_timeout():
	if current_mushroom > 3:
		$"Timer".stop()
		_start_round()
		return
	if not $"Mushrooms".get_child(current_mushroom).name.begins_with("None"):
		$"MushroomSounds".get_child(notes[current_mushroom]).play()
		$"Mushrooms".get_child(current_mushroom).get_node("AnimationPlayer").play("default")
	current_mushroom += 1

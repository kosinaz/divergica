extends Node2D

var current_mushroom = 0
var notes = []
var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	$"MushroomAnimationPlayer".play("default")
	for _i in range(4):
		notes.append(rng.randi_range(0, 3))

func _play_note():
	$"MushroomSounds".get_child(notes[current_mushroom]).play()
	current_mushroom = (current_mushroom + 1) % 4

func _start_round():
	$"PaintButton".show()
	$"BrushAnimationPlayer".play("0to1")

func _on_paint_button_pressed():
	if current_mushroom > 3:
		return
	var path = $"Mushrooms".get_child(current_mushroom).texture.load_path
	if "black".is_subsequence_of(path):
		$"Brush".get_node("Error").play()
		current_mushroom += 1
		return
	if "striped".is_subsequence_of(path):
		if "painted".is_subsequence_of(path):
			$"Mushrooms".get_child(current_mushroom).texture = load("res://assets/mushroom_striped_painted_twice.png")
			$"Brush".get_child(notes[current_mushroom]).play()
			current_mushroom += 1
		else:
			$"Mushrooms".get_child(current_mushroom).texture = load("res://assets/mushroom_striped_painted_once.png")
			$"Brush".get_child(notes[current_mushroom]).play()
	else:
		$"Mushrooms".get_child(current_mushroom).texture = load("res://assets/mushroom_painted.png")
		$"Brush".get_child(notes[current_mushroom]).play()
		current_mushroom += 1

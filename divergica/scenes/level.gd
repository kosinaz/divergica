extends Node2D

var current_mushroom = 0
var notes = []
var rng = RandomNumberGenerator.new()

onready var mushrooms = get_tree().get_nodes_in_group("mushrooms")

func _ready():
	add_child(load("res://scenes/level_engine.tscn").instance())
	rng.randomize()
	for _i in range(4):
		notes.append(rng.randi_range(0, 3))
	for mushroom in mushrooms:
		mushroom.hide()
# warning-ignore:return_value_discarded
	$"LevelEngine/LeadTimer".connect("timeout", self, "_on_lead_timer_timeout")
# warning-ignore:return_value_discarded
	$"LevelEngine/FollowTimer".connect("timeout", self, "_on_follow_timer_timeout")
# warning-ignore:return_value_discarded
	$"LevelEngine/PaintButton".connect("pressed", self, "_on_paint_button_pressed")

func _start_round():
	$"LevelEngine/PaintButton".show()
	$"LevelEngine/FollowTimer".start()
	$"LevelEngine/BrushAnimationPlayer".play("0to1")
	current_mushroom = -1

func _on_paint_button_pressed():
	if $"LevelEngine/FollowTimer".time_left < 0.5 or current_mushroom == -1:
		$"LevelEngine/Brush".get_node("Error").play()
		return
	var mushroom = mushrooms[current_mushroom]
	match mushroom.animation:
		"black":
			$"LevelEngine/Brush".get_node("Error").play()
		"striped":
			$"LevelEngine/Brush".get_child(notes[current_mushroom]).play()
			mushroom.play("once")
		"once":
			$"LevelEngine/Brush".get_child(notes[current_mushroom]).play()
			mushroom.play("twice")
		"white":
			$"LevelEngine/Brush".get_child(notes[current_mushroom]).play()
			mushroom.play("painted")

func _on_lead_timer_timeout():
	var mushroom = mushrooms[current_mushroom]
	if current_mushroom > 3:
		$"LevelEngine/LeadTimer".stop()
		_start_round()
		return
	if not mushroom.name.begins_with("None"):
		$"LevelEngine/MushroomSounds".get_child(notes[current_mushroom]).play()
		mushroom.get_child(0).play("mushroom_animation")
	current_mushroom += 1

func _on_follow_timer_timeout():
	current_mushroom += 1
	if current_mushroom == 0:
		$"LevelEngine/BrushAnimationPlayer".play("1to2")
	if current_mushroom == 1:
		$"LevelEngine/BrushAnimationPlayer".play("2to3")
	if current_mushroom == 2:
		$"LevelEngine/BrushAnimationPlayer".play("3to4")
	if current_mushroom > 3:
		$"LevelEngine/FollowTimer".stop()
		$"LevelEngine/PaintButton".hide()

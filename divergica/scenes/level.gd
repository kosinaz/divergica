extends Node2D

var current_mushroom = 0
var turn = 0
var notes = []
var rng = RandomNumberGenerator.new()

onready var mushrooms = get_tree().get_nodes_in_group("mushrooms")

func _ready():
	add_child(load("res://scenes/level_engine.tscn").instance())
	rng.randomize()
	for _i in range(12):
		notes.append(rng.randi_range(0, 3))
	for mushroom in mushrooms:
		mushroom.hide()
# warning-ignore:return_value_discarded
	$"LevelEngine/LeadTimer".connect("timeout", self, "_on_lead_timer_timeout")
# warning-ignore:return_value_discarded
	$"LevelEngine/FollowTimer".connect("timeout", self, "_on_follow_timer_timeout")
# warning-ignore:return_value_discarded
	$"LevelEngine/PaintButton".connect("pressed", self, "_on_paint_button_pressed")
# warning-ignore:return_value_discarded
	$"LevelEngine/ContinueButton".connect("pressed", self, "_on_continue_button_pressed")

func _start_turn():
	$"LevelEngine/FollowTimer".start()
	$"LevelEngine/BrushAnimationPlayer".play("brush_animation")
	current_mushroom = -1

func _on_continue_button_pressed():
	turn += 1
	$"LevelEngine/ContinueButton".hide()
	$"LevelEngine/EngineAnimationPlayer".play("pan" + str(turn))
	$"LevelEngine/LeadTimer".start()
	$"LevelEngine/PaintButton".show()
	$"LevelEngine/PaintButton".disabled = true
	current_mushroom = 0

func _on_paint_button_pressed():
	if $"LevelEngine/FollowTimer".time_left < 0.4 or current_mushroom == -1:
		$"LevelEngine/BrushSounds".get_node("Error").play()
		return
	var mushroom = mushrooms[current_mushroom + turn * 4]
	if not mushroom is AnimatedSprite:
		$"LevelEngine/BrushSounds".get_node("Error").play()
		return
	match mushroom.animation:
		"black":
			$"LevelEngine/BrushSounds".get_node("Error").play()
		"striped":
			$"LevelEngine/BrushSounds".get_child(notes[current_mushroom + turn * 4]).play()
			mushroom.play("once")
		"once":
			$"LevelEngine/BrushSounds".get_child(notes[current_mushroom + turn * 4]).play()
			mushroom.play("twice")
		"white":
			$"LevelEngine/BrushSounds".get_child(notes[current_mushroom + turn * 4]).play()
			mushroom.play("painted")

func _on_lead_timer_timeout():
	if current_mushroom > 3:
		$"LevelEngine/LeadTimer".stop()
		_start_turn()
		return
	var mushroom = mushrooms[current_mushroom + turn * 4]
	if not mushroom.name.begins_with("None"):
		$"LevelEngine/MushroomSounds".get_child(notes[current_mushroom + turn * 4]).play()
		mushroom.get_child(0).play("mushroom_animation")
	current_mushroom += 1

func _on_follow_timer_timeout():
	current_mushroom += 1
	if current_mushroom < 4:
		$"LevelEngine/PaintButton".disabled = false
	else:
		$"LevelEngine/FollowTimer".stop()
		$"LevelEngine/PaintButton".hide()
		if turn < 2:
			$"LevelEngine/ContinueButton".show()

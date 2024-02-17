extends Node2D

var current_mushroom = 0
var turn = 0
var notes = []
var rng = RandomNumberGenerator.new()
var config = ConfigFile.new()
var painted = 0
var available = 0
var gold = 0
var miss = 0
var blocked_note = -1

onready var mushrooms = get_tree().get_nodes_in_group("mushrooms")

func _ready():
	rng.randomize()
	for _i in range(12):
		notes.append(rng.randi_range(0, 3))
	for mushroom in mushrooms:
		mushroom.hide()
		if not mushroom.name.begins_with("None") and not mushroom.name.begins_with("Black"):
			available += 1
	$"LevelEngine/Miss1".hide()
	$"LevelEngine/Miss2".hide()
	$"LevelEngine/Miss3".hide()
# warning-ignore:return_value_discarded
	$"LevelEngine/LeadTimer".connect("timeout", self, "_on_lead_timer_timeout")
# warning-ignore:return_value_discarded
	$"LevelEngine/FollowTimer".connect("timeout", self, "_on_follow_timer_timeout")
# warning-ignore:return_value_discarded
	$"LevelEngine/PaintButton".connect("pressed", self, "_on_paint_button_pressed")
# warning-ignore:return_value_discarded
	$"LevelEngine/ContinueButton".connect("pressed", self, "_on_continue_button_pressed")
	$"LevelEngine/GoldTotal/GoldContainer/Label".text = str(0)
	$"LevelEngine/LevelNameLabel".text = name

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
	var mushroom = mushrooms[current_mushroom + turn * 4]
	if $"LevelEngine/FollowTimer".time_left < 0.4 or current_mushroom == -1 or not mushroom is AnimatedSprite or mushroom.animation == "black" or blocked_note == current_mushroom + turn * 4:
		$"LevelEngine/BrushAnchor/BrushOffset/Brush/Error/AnimationPlayer".stop()
		$"LevelEngine/BrushAnchor/BrushOffset/Brush/Error/AnimationPlayer".play("show")
		$"LevelEngine/BrushAnchor/BrushOffset/Brush/Penalty/AnimationPlayer".stop()
		$"LevelEngine/BrushAnchor/BrushOffset/Brush/Penalty/AnimationPlayer".play("show")
		gold -= 250
		$"LevelEngine/GoldTotal/GoldContainer/Label".text = str(gold)
		if $"LevelEngine/FollowTimer".time_left < 0.4:
			blocked_note = current_mushroom + turn * 4 + 1
		return
	if mushroom.animation == "painted" or mushroom.animation == "twice":
		return
	var current_gold = int(stepify(pow($"LevelEngine/FollowTimer".time_left * 10, 3), 10))
	if mushroom.animation == "once":
		current_gold *= 2
	gold += current_gold
	$"LevelEngine/GoldTotal/GoldContainer/Label".text = str(gold)
	var position_x = current_mushroom * 128 + 320
	$"LevelEngine/Gold".position.x = position_x
	$"LevelEngine/Gold/GoldContainer/Label".text = str(current_gold)
	$"LevelEngine/Gold/AnimationPlayer".stop()
	$"LevelEngine/Gold/AnimationPlayer".play("show")
	match mushroom.animation:
		"striped":
			$"LevelEngine/BrushSounds".get_child(notes[current_mushroom + turn * 4]).play()
			mushroom.play("once")
		"once":
			$"LevelEngine/BrushSounds".get_child(notes[current_mushroom + turn * 4]).play()
			mushroom.play("twice")
			painted += 1
		"white":
			$"LevelEngine/BrushSounds".get_child(notes[current_mushroom + turn * 4]).play()
			mushroom.play("painted")
			painted += 1

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
	var id = current_mushroom + turn * 4
	if id >= 0:
		var mushroom = mushrooms[id]
		if mushroom is AnimatedSprite and ["white", "striped", "once"].has(mushroom.animation):
			mushroom.play("missed")
			miss += 1
			if miss > 3:
				_save_results()
# warning-ignore:return_value_discarded
				get_tree().change_scene("res://scenes/fail.tscn")
				return
			$"LevelEngine".get_node("Miss" + str(miss)).show()
			var position_x = current_mushroom * 128 + 320
			$"LevelEngine/Penalty".position.x = position_x
			$"LevelEngine/Penalty/AnimationPlayer".stop()
			$"LevelEngine/Penalty/AnimationPlayer".play("show")
			gold -= 250
			$"LevelEngine/GoldTotal/GoldContainer/Label".text = str(gold)
	current_mushroom += 1
	if current_mushroom < 4:
		$"LevelEngine/PaintButton".disabled = false
	else:
		$"LevelEngine/FollowTimer".stop()
		$"LevelEngine/PaintButton".hide()
		if turn < 2:
			$"LevelEngine/ContinueButton".show()
		else:
			_save_results()
			if miss > 3:
# warning-ignore:return_value_discarded
				get_tree().change_scene("res://scenes/fail.tscn")
			else:
# warning-ignore:return_value_discarded
				get_tree().change_scene("res://scenes/win.tscn")

func _save_results():
	var result = config.load("user://config.cfg")
	if not result == OK:
		print("couldn't load config")
	config.set_value("global", "level", name)
	config.set_value(name, "painted", painted)
	config.set_value(name, "available", available)
	config.set_value(name, "gold", gold)
	var current_award = 4 - max(miss, 0)
	var award = config.get_value(name, "award", 0)
	if award < current_award:
		config.set_value(name, "award", current_award)
	result = config.save("user://config.cfg")
	if not result == OK:
		print("coulnd't save config")

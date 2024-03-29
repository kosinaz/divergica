extends TextureButton

var config = ConfigFile.new()

func _on_pressed():
	var result = config.load("user://config.cfg")
	var level = "Level1"
	if not result == OK:
		print("couldn't load config")
	else:
		level = config.get_value("global", "level")
	var id = int(level.substr(5))
	var next_level = "Level" + str(id + 1)
# warning-ignore:return_value_discarded
	if next_level == "Level2" and int(config.get_value("Level2", "painted", 0)) == 0:
# warning-ignore:return_value_discarded
		get_tree().change_scene("res://scenes/tutorial2.tscn")
	elif next_level == "Level3" and int(config.get_value("Level3", "painted", 0)) == 0:
# warning-ignore:return_value_discarded
		get_tree().change_scene("res://scenes/tutorial3.tscn")
	else:
# warning-ignore:return_value_discarded
		get_tree().change_scene("res://scenes/" + next_level.to_lower() + ".tscn")

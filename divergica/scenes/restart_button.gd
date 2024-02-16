extends TextureButton

var config = ConfigFile.new()

func _on_pressed():
	var result = config.load("user://config.cfg")
	var level = "Level1"
	if not result == OK:
		print("couldn't load config")
	else:
		level = config.get_value("global", "level")
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://scenes/" + level.to_lower() + ".tscn")

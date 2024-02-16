class_name LevelButton
extends TextureButton

export var level = "Level1"

var config = ConfigFile.new()

func _ready():
	var result = config.load("config.cfg")
	if not result == OK:
		print("couldn't load config")
		return
	if level == "Level1":
		disabled = false
	var id = int(level.substr(5))

func _on_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://scenes/" + level.to_lower() + ".tscn")

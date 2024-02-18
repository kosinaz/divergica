class_name LevelButton
extends TextureButton

export var level = "Level1"

var config = ConfigFile.new()

func _ready():
	var result = config.load("user://config.cfg")
	if not result == OK:
		print("couldn't load config")
		return
	if level == "Level1":
		disabled = false
		$"%Label".show()
	else:
		var id = int(level.substr(5))
		var previous = int(config.get_value("Level" + str(id - 1), "award", 0))
		if previous > 0:
			disabled = false
			$"%Label".show()
			$"%Label".text = str(id)
	var award = int(config.get_value(level, "award", 0))
	if award > 0:
		award = max(1, award - 1)
		texture_normal = load("res://assets/level_button_done_" + str(award) + ".png")

func _on_pressed():
# warning-ignore:return_value_discarded
	if level == "Level1" and int(config.get_value("Level1", "painted", 0)) == 0:
		get_tree().change_scene("res://scenes/tutorial1.tscn")
	elif level == "Level2" and int(config.get_value("Level2", "painted", 0)) == 0:
# warning-ignore:return_value_discarded
		get_tree().change_scene("res://scenes/tutorial2.tscn")
	elif level == "Level3" and int(config.get_value("Level3", "painted", 0)) == 0:
# warning-ignore:return_value_discarded
		get_tree().change_scene("res://scenes/tutorial3.tscn")
	else:
# warning-ignore:return_value_discarded
		get_tree().change_scene("res://scenes/" + level.to_lower() + ".tscn")

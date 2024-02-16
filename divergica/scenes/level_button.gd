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
		texture_normal = load("res://assets/level_button_done_" + str(award) + ".png")

func _on_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://scenes/" + level.to_lower() + ".tscn")

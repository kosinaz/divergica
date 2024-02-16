extends Control

var config = ConfigFile.new()

func _ready():
	var result = config.load("user://config.cfg")
	if not result == OK:
		print("couldn't load config")
		return
	var level = config.get_value("global", "level")
	var painted = int(config.get_value(level, "painted"))
	var painted_max = int(config.get_value(level, "painted_max", 0))
	var available = int(config.get_value(level, "available"))
	var gold = int(config.get_value(level, "gold"))
	var gold_max = int(config.get_value(level, "gold_max", 0))
	var award = int(config.get_value(level, "award", 1))
	config.set_value(level, "painted_max", max(painted, painted_max))
	config.set_value(level, "gold_max", max(gold, gold_max))
	result = config.save("user://config.cfg")
	if not result == OK:
		print("coulnd't save config")
	$"%MushroomTexture".texture.current_frame = award - 1
	$"%MushroomsLabel".text = str(painted) + "/" + str(available) + " (" + str(painted_max) + "/" + str(available) + ")"
	$"%GoldLabel".text = str(gold) + " (" + str(gold_max) + ")"

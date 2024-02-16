extends Control

var config = ConfigFile.new()

func _ready():
	var result = config.load("user://config.cfg")
	if not result == OK:
		print("couldn't load config")
		return
	var level = config.get_value("global", "level")
	var painted = int(config.get_value(level, "painted"))
	var available = int(config.get_value(level, "available"))
	$"%MushroomsLabel".text = str(painted) + "/" + str(available)
	$"%TipLabel".text = "Paint " + str(available - 2 - painted) + " more to win!"

extends Control

var config = ConfigFile.new()

func _ready():
	var result = config.load("user://config.cfg")
	if not result == OK:
		print("couldn't load config")
		return
	var level = config.get_value("global", "level")
	var painted = config.get_value(level, "painted")
	var painted_max = config.get_value(level, "painted_max", painted)
	var available = config.get_value(level, "available")
	var gold = config.get_value(level, "gold")
	var gold_max = config.get_value(level, "gold_max", gold)
	config.set_value(level, "painted_max", max(painted, painted_max))
	config.set_value(level, "gold_max", max(gold, gold_max))
	result = config.save("user://config.cfg")
	if not result == OK:
		print("coulnd't save config")
	if available == painted_max + 1:
		$"%MushroomTexture".texture.current_frame = 1
	if available == painted_max:
		$"%MushroomTexture".texture.current_frame = 2
	$"%MushroomsLabel".text = str(painted) + "/" + str(available) + " (" + str(painted_max) + "/" + str(available) + ")"
	$"%GoldLabel".text = str(gold) + " (" + str(gold_max) + ")"

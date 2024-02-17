extends Label

var config = ConfigFile.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	var result = config.load("user://config.cfg")
	if not result == OK:
		print("couldn't load config")
		return
	var gold = 0
	for id in range(1, 5):
		gold += int(config.get_value("Level" + str(id), "gold_max", 0))
	text = str(gold)

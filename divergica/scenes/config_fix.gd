extends Node2D

var config = ConfigFile.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	var result = config.load("config.cfg")
	if not result == OK:
		print("couldn't load config")
		return
	config.save("user://config.cfg")
	get_tree().quit()

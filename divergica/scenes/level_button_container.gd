extends GridContainer

var button_scene = load("res://scenes/level_button.tscn")

func _ready():
	var button = button_scene.instance()
	button.set_enabled(1)
	button.connect("pressed", self, "_start_level", [1])
	add_child(button)
	for _i in range(1, 15):
		button = button_scene.instance()
		add_child(button)

func _start_level(id):
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://scenes/level" + str(id) + ".tscn")

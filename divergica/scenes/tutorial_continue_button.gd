extends TextureButton

export var level = "Level1"

func _on_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://scenes/" + level.to_lower() + ".tscn")

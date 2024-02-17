extends TextureButton

var config = ConfigFile.new()

func _on_pressed():
	get_tree().paused = false
# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()

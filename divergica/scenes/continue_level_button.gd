extends TextureButton

func _on_pressed():
	get_parent().hide()
	get_tree().paused = false

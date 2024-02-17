extends TextureButton

func _on_pressed():
	$"../PauseWindow".show()
	get_tree().paused = true

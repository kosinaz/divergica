class_name LevelButton
extends TextureButton

func set_enabled(id):
	disabled = false
	$"%Label".text = str(id)
	$"%Label".show()

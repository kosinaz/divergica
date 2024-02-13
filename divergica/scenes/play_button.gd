extends TextureButton

func _on_pressed():
	get_parent().get_node("Levels").show()

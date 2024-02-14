extends Node2D

var current_mushroom = 0

func _on_paint_button_pressed():
	if current_mushroom > 3:
		return
	$"Mushrooms".get_child(current_mushroom).texture = load("res://assets/mushroom_painted.png")
	current_mushroom += 1

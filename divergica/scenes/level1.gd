extends Node2D

var current_mushroom = 0
var turn = 0

func _show_next_mushroom():
	if turn == 1: return
	if current_mushroom > 3:
		current_mushroom = 0
		turn += 1
		return
	$"Paints".get_child(current_mushroom).show()
	$"Paints".get_child(current_mushroom).get_child(0).play()
	current_mushroom += 1

func _on_paint_button_pressed():
	if current_mushroom > 3:
		return
	$"Mushrooms".get_child(current_mushroom).texture = load("res://assets/mushroom_painted.png")
	$"Mushrooms".get_child(current_mushroom).get_child(0).play()
	current_mushroom += 1

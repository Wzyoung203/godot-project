extends Node2D

var left_input: String = ""
var right_input: String = ""


func process_input(left_gesture: String, right_gesture: String) -> void:
	left_input = left_gesture
	right_input = right_gesture

extends Node2D

var _left_input: String = ""
var _right_input: String = ""

var _history_left_input: Array = []
var _history_right_input: Array = []

var history_left_input_string: String
var history_right_input_string: String

func _ready() -> void:
	Events.spells_on_hands.connect(_process_input)

func _process_input(left_gesture: String, right_gesture: String) -> void:
	_left_input = left_gesture
	_right_input = right_gesture
	if _history_left_input.size() > 10:
		_history_left_input.pop_front()
	if _history_right_input.size() > 10:
		_history_right_input.pop_front()
	_history_left_input.append(_left_input)
	_history_right_input.append(_right_input)
	#print("History left inputs: ",_history_left_input)
	#print("History right inputs: ",_history_right_input)
	
	history_left_input_string = _Array_to_String(_history_left_input)
	history_right_input_string = _Array_to_String(_history_right_input)
	print("History left inputs: ",history_left_input_string)
	Events.input_process_success.emit()
	#print("History right inputs: ",history_right_input_string)

func _Array_to_String(inputs: Array) -> String:
	var res : String = ""
	for char : String in inputs:
		res += char
	return res
	

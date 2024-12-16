extends Control

var left_gesture: String
var right_gesture: String

signal end_turn
signal spells(left_gesture, right_gesture)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

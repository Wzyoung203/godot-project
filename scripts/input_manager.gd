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

func _on_end_turn_button_pressed() -> void:
	Events.player_turn_end.emit()
	left_gesture = $LeftHand.get_item_text($LeftHand.get_selected_id())
	right_gesture = $RightHand.get_item_text($RightHand.get_selected_id())
	if left_gesture == right_gesture:
		left_gesture=left_gesture.to_upper()
		right_gesture=right_gesture.to_upper()
	Events.spells_on_hands.emit(left_gesture,right_gesture)

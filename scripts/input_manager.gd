extends Control

@onready var left_hand : OptionButton = $LeftHand as OptionButton
@onready var rgiht_hand : OptionButton = $RightHand as OptionButton
@onready var end_btn : Button = $EndTurnButton as Button

signal end_turn
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_hands_visible():
	left_hand.visible = true
	rgiht_hand.visible = true
	
func set_hands_invisible():
	left_hand.visible = false
	rgiht_hand.visible = false
	
func _on_end_turn_button_pressed() -> void:
	end_turn.emit()

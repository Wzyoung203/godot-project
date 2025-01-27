extends Panel

@onready var player_inputs: ItemList = $PlayerInputs
@onready var ai_inputs: ItemList = $AIInputs

func _ready() -> void:
	Events.spells_on_hands.connect(_load_player_inputs)
	Events.ai_gestures.connect(_load_ai_inputs)

func _on_close_button_pressed() -> void:
	visible = false

func _load_player_inputs(lefthand:String,rightHand:String):
	player_inputs.add_item(lefthand,null,false)
	player_inputs.add_item(rightHand,null,false)
		
func _load_ai_inputs(lefthand:String,rightHand:String):
	ai_inputs.add_item(lefthand,null,false)
	ai_inputs.add_item(rightHand,null,false)

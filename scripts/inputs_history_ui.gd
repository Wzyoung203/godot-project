extends Panel

@onready var player_inputs: ItemList = $PlayerInputs
@onready var ai_inputs: ItemList = $AIInputs

func _ready() -> void:
	Events.spells_on_hands.connect(_load_player_inputs)

func _on_close_button_pressed() -> void:
	visible = false

func _load_player_inputs(lefthand:String,rightHand:String):
	player_inputs.add_item(lefthand,null,false)
	player_inputs.add_item(rightHand,null,false)
		

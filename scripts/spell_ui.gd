extends VBoxContainer
@onready var menu = $ItemList
@onready var confirm = $HBoxContainer/Confirm
@onready var label: Label = $Label
var selected:int
var hand:String
func _ready() -> void:
	hand = "left"
	Events.event_creat_success.connect(check_status)

func check_status():
	if hand == "right":
		Events.select_end.emit()
	else:
		Events.left_selected.emit()
		

func display(spells: Array[Spell],hand:String) -> void:
	self.hand = hand
	label.text = hand + " spells"
	visible = true
	menu.visible = true
	var i = 0
	for spell in spells:
		menu.add_item(spell.getName())
		menu.set_item_metadata(i, spell)
		i=i+1
	var screen_size = get_viewport_rect().size
	var component_size = self.size
	var new_position = (screen_size - component_size) / 2
	self.global_position = new_position

# 取消选择法术
func _cancel():
	menu.clear()
	visible = false
	check_status()

func _activate_confirm_btn(index: int):
	selected = index
	confirm.disabled = false
	
func _confirm():
	var spell:Spell = menu.get_item_metadata(selected) as Spell
	#print("已选中法术：",spell.getName())
	confirm.disabled = true
	menu.clear()
	visible = false
	spell.set_caster(self.get_parent().get_parent())
	Events.selected_spell.emit(spell)

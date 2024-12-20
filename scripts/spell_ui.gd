extends VBoxContainer
@onready var menu = $ItemList
@onready var confirm = $HBoxContainer/Confirm
func display(spells: Array[Spell]) -> void:
	visible = true
	menu.visible = true
	var i = 0
	for spell in spells:
		menu.add_item(spell.getName())
		menu.set_item_metadata(i, spell)
		i=i+1
	

func _cancel():
	menu.clear()
	visible = false

func _activate_confirm_btn(index: int):
	confirm.disabled = false
	
func _confirm():
	 
	var spell:Spell = menu.get_item_metadata(0) as Spell
	print("已选中法术：",spell.getName())
	confirm.disabled = true
	menu.clear()
	visible = false
	
	Events.selected_spell.emit(spell)
	

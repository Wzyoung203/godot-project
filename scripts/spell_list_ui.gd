extends Panel
@onready var close_button: Button = $CloseButton
@onready var scroll_container: ScrollContainer = $ScrollContainer
@onready var vbox: VBoxContainer = $ScrollContainer/BoxContainer

func _ready() -> void:
	_load_spell_list()

func _on_close_button_pressed() -> void:
	visible = false

func _load_spell_list():
	var list = STree.spell_tree.spellList
	for spell in list:
		
		var label = Label.new()
		label.text = spell.getName()+": "+spell.sequences
		vbox.add_child(label)
	

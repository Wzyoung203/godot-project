extends Node2D

var left_vaild_spells: Array[Spell] = []
var right_vaild_spells: Array[Spell] = []

var spell_tree: SpellTree
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spell_tree = STree.spell_tree
	
	Events.input_process_success.connect(enquiry_vaild_spell)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func enquiry_vaild_spell():
	print("Which Spell do you want to use?")
	left_vaild_spells = spell_tree.search_valid_spells($InputProcessor.history_left_input_string)
	display_vaild_spell(left_vaild_spells)
	right_vaild_spells = spell_tree.search_valid_spells($InputProcessor.history_right_input_string)
	#TODO.. 
	# display_vaild_spell(right_vaild_spells)


func display_vaild_spell(spells: Array[Spell]):
	$SpellUI.display(spells)

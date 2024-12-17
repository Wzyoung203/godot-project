extends Node2D

var left_vaild_spells: Array = []
var right_vaild_spells: Array = []

var STree: SpellTree
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	STree = SpellTree.new()
	STree.preload_trie()
	STree.print_spells()
	
	Events.input_process_success.connect(enquiry_vaild_spell)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func enquiry_vaild_spell():
	print("Which Spell do you want to use?")
	left_vaild_spells = STree.search_valid_spells($InputProcessor.history_left_input_string)
	right_vaild_spells = STree.search_valid_spells($InputProcessor.history_right_input_string)
	

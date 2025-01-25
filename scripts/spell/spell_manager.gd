extends Node2D

var left_vaild_spells: Array[Spell] = []
var right_vaild_spells: Array[Spell] = []

var spell_tree: SpellTree
@onready var input_history: Label = $"../InputHistory"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spell_tree = STree.spell_tree
	Events.left_selected.connect(display_right_vaild_spell)
	Events.input_process_success.connect(enquiry_vaild_spell)

func get_last_five_characters(input_string: String) -> String:
	var length = input_string.length()
	if length <= 5:
		return input_string  # 如果字符串长度小于等于5，直接返回整个字符串
	else:
		return input_string.right(5)  # 获取后五个字符

func enquiry_vaild_spell():
	#print("Which Spell do you want to use?")
	left_vaild_spells = spell_tree.search_valid_spells($InputProcessor.history_left_input_string)
	right_vaild_spells = spell_tree.search_valid_spells($InputProcessor.history_right_input_string)
	
	var l_his = get_last_five_characters($InputProcessor.history_left_input_string)
	var r_his = get_last_five_characters($InputProcessor.history_right_input_string)
	var display_result = ""
	for i in len(l_his):
		display_result += l_his[i] + "----" + r_his[i] + "\n"

		
	input_history.text = display_result
	
	if (left_vaild_spells.size() == 0 and right_vaild_spells.size() == 0):
		Events.no_valid_spell.emit()
	else:
		if left_vaild_spells.size() != 0:
			display_left_vaild_spell(left_vaild_spells)
		else:
			display_right_vaild_spell()
	
	
func display_left_vaild_spell(spells: Array[Spell]):
	$SpellUI.display(spells,"left")
func display_right_vaild_spell():
	if right_vaild_spells.size() == 0:
		#print("右手法术为空")
		Events.select_end.emit()
		return
	$SpellUI.display(right_vaild_spells,"right")

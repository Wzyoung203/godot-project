extends Node2D

# 系统中的法术树
var spell_tree: SpellTree = STree.spell_tree
# 系统中的可选目标
var _targets:Array[Character]

# ai从系统中获取的历史输入记录(包括敌我双方)
var _history_input:Array

# 本回合ai左右手计划的手势
var _cur_input_left:String
var _cur_input_right:String

# 最近十次左右手手势
var _his_input_left:String=""
var _his_input_right:String=""

# 本回合可用法术
var _left_vaild_spells: Array[Spell] = []
var _right_vaild_spells: Array[Spell] = []

# six gestures and stab(o)
var _gestures:Array = ["f","p","s","w","d","c","o"]

# 本回合ai的法术（如有）
var _cur_spell:Array[Spell]
# 本回合ai的法术（如有）目标
var _cur_target:Array[Character]

# 旧线程的引用
var ai_thread: Thread = null
# 创建一个互斥锁，用于线程安全
var ai_mutex = Mutex.new()

@onready var input_history: Label = $"../InputHistory"
func _ready() -> void:
	Events.player_turn.connect(_ai_start)

func _ai_start():
	# 启动子线程
	ai_thread = Thread.new()
	ai_thread.start(_ai_thinking)

func _ai_thinking():
	# 输入本回合的手势
	# Enter the gesture for this round
	if _cur_input_left == _gestures[4] or _cur_input_left == _gestures[4].to_upper():
		_cur_input_left = _gestures[2]
		_cur_input_right = _gestures[2]
	else:
		_cur_input_left = _gestures[4]
		_cur_input_right = _gestures[4]
	print(_cur_input_left,_cur_input_right)
	
	# 预处理手势，相同记为大写
	if _cur_input_left == _cur_input_right:
		_cur_input_left=_cur_input_left.to_upper()
		_cur_input_right=_cur_input_right.to_upper()
	
	# 将输入传入历史输入中，判断有无可用法术
	_his_input_left += _cur_input_left
	_his_input_right += _cur_input_right
	_his_input_left = _his_input_left.right(10)
	_his_input_right = _his_input_right.right(10)
	call_deferred("_emit_gesture_signal")
	
	
	
	
	# 判断本回合有无可用法术
	#Determine if there are any available spells in this round
	_left_vaild_spells = spell_tree.search_valid_spells(_his_input_left)
	_right_vaild_spells = spell_tree.search_valid_spells(_his_input_right)
	
	if _left_vaild_spells.size() > 0:
		print("left valid spell:",_left_vaild_spells[0].getName())
		# 如有选择哪个释放
		#If there is a choice, which one to release
		_cur_spell.append(_left_vaild_spells[0])
		
		
		# 释放目标怎么选择
		#How to choose the target for release
		
		
		
	if _right_vaild_spells.size() > 0:
		print("left valid spell:",_right_vaild_spells[0].getName())
		# 如有选择哪个释放
		#If there is a choice, which one to release
		_cur_spell.append(_right_vaild_spells[0])
		
		
		
		# 释放目标怎么选择
		#How to choose the target for release
	
	
	
	
	
	
	call_deferred("_finish_thread")
		
	
func _finish_thread():
	if ai_thread != null:
		ai_thread.wait_to_finish()
		print("AI: Thread has already finished")
	
func _emit_gesture_signal():
	Events.ai_gestures.emit(_cur_input_left,_cur_input_right)
	var display_result = ""
	var l_his = _his_input_left.right(5)
	var r_his = _his_input_right.right(5)
	for i in len(l_his):
		display_result += l_his[i] + "----" + r_his[i] + "\n"
	input_history.text = display_result


func set_tagets(charaters:Array[Character]):
	_targets = charaters

func add_tagets(character:Character):
	_targets.append(character)

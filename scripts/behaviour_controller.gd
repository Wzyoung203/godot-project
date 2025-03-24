extends Node2D

# 系统中的法术树
var spell_tree: SpellTree = STree.spell_tree

# 记录当前回合数
var turn_cnt = 0
# 本回合ai的法术（如有）
var _cur_spell:Array[Spell] = []
# 本回合ai的法术（如有）目标
var _cur_targets:Array[Role] = []

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
# 系统中的可选目标
var _targets: Array[Role] = []
# six gestures and stab(o)
var _gestures:Array = ["f","p","s","w","d","c","o"]

var start_time
var end_time
# 旧线程的引用
var ai_thread: Thread = null
# 创建一个互斥锁，用于线程安全
var ai_mutex = Mutex.new()
var ai_csharp
@onready var input_history: Label = $"../InputHistory"
func _ready() -> void:
	Events.player_turn.connect(_ai_start)
	Events.creature_changed.connect(set_tagets)
	Events.ai_behaviour_finished.connect(_emit_spell_target_signal)
	Events.turn_end.connect(load_input_history)
	var my_csharp_script = load("res://scripts/CSscripts/GameAI.cs")
	ai_csharp = my_csharp_script.new()
	

func _ai_start():
	# 启动子线程
	turn_cnt+=1
	ai_thread = Thread.new()
	start_time = Time.get_unix_time_from_system()	
	ai_thread.start(_ai_thinking)

	
func parse_move_string(move_string: String) -> Move:
	# 将输入字符串按行分割
	var lines = move_string.split("\n")
	
	# 检查输入是否完整
	if len(lines) < 6:
		push_error("Invalid move string format. Expected 6 lines.")
		return null

	# 解析每一行
	var left_hand = lines[0]
	var right_hand = lines[1]
	var left_spell = lines[2]
	var left_target = int(lines[3]) if lines[3] != "" else -1
	var right_spell = lines[4]
	var right_target = int(lines[5]) if lines[5] != "" else -1

	# 创建 Move 实例并返回
	return Move.new(left_hand, right_hand, left_spell, left_target, right_spell, right_target)
	
func _ai_thinking():
	
	# 用minimax算法找到最佳下一步
	var res = ai_csharp.FindBestMove(Game_Status._to_string(),turn_cnt)
	var m:Move = parse_move_string(res)
	print(res)
	
	_cur_input_left = m.get_left_hand()
	_cur_input_right = m.get_right_hand()
	
	ai_mutex.lock()
	
	if (m._left_spell!=""):
		var a:Spell = STree.spell_tree.search_in_spell_list(m._left_spell)	
		a.set_caster(self.get_parent())
		_cur_spell.append(a)
		
	if (m._right_spell!=""):
		var a:Spell = STree.spell_tree.search_in_spell_list(m._right_spell)	
		a.set_caster(self.get_parent())
		_cur_spell.append(a)
	if (m._left_target!=-1):	call_deferred("add_cur_tagets",m._left_target)
	if (m._right_target!=-1):	call_deferred("add_cur_tagets",m._right_target)
	ai_mutex.unlock()
	
	call_deferred("_emit_gesture_signal")
	call_deferred("_finish_thread")

	
	

func _finish_thread():
	if ai_thread != null:
		ai_thread.wait_to_finish()
		end_time = Time.get_unix_time_from_system()
		
		print("AI: Thread has already finished")
		# 计算线程运行时间（单位：毫秒）
		var elapsed_time = end_time - start_time
		print("Thread running time: ", elapsed_time, " s") 
		
		Events.ai_behaviour_finished.emit()

func _emit_gesture_signal():
	Events.ai_gestures.emit(_cur_input_left,_cur_input_right)
	


# 告知系统本回合选择的法术及目标
func _emit_spell_target_signal():
	Events.ai_cur_spells_targets.emit(_cur_spell,_cur_targets)
	_cur_spell.clear()
	_cur_targets.clear()

func add_cur_tagets(index:int):
	_cur_targets.append(_targets[index])

func load_input_history():
	_his_input_left += _cur_input_left
	_his_input_right += _cur_input_right
	_his_input_left = _his_input_left.right(10)
	_his_input_right = _his_input_right.right(10)
	var display_result = ""
	var l_his = _his_input_left.right(5)
	var r_his = _his_input_right.right(5)
	for i in len(l_his):
		display_result += l_his[i] + "----" + r_his[i] + "\n"
	input_history.text = display_result
	Game_Status.set_p2_left_hand(_his_input_left)
	Game_Status.set_p2_right_hand(_his_input_right)

func set_tagets(charaters:Array[Role]):
	_targets = charaters

func add_tagets(character:Role):
	_targets.append(character)

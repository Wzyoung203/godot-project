extends Node

@onready var turnStage: Label = $TurnStage as Label

enum TurnState {
	PLAYER_TURN,
	SPELL_SELECT,
	SPELL_EFFECT,
	TURN_END
}

var current_turn_state = TurnState.PLAYER_TURN
# We need two players to finish their respective rounds 
#before moving on to the next stage
var ready_cnt = 0
#ai behaviour finished flag
var ai_flag = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Events.player_turn_end.connect(spell_select)
	Events.select_end.connect(effect_spells)
	Events.effect_end.connect(end_turn)
	Events.ai_events_created.connect(effect_spells)

func ai_finished():
	ai_flag = 1

func start_player_turn():
	current_turn_state = TurnState.PLAYER_TURN
	update_turn_state("PLAYER TURN")
	Events.player_turn.emit()

# 处理玩家和AI的选择目标(在玩家对象中实现)
func spell_select():
	current_turn_state = TurnState.SPELL_SELECT
	update_turn_state("SPELL SELECT")
	Events.spell_select.emit()
	

func effect_spells():
	ready_cnt += 1
	if ready_cnt != 2:
		return
	current_turn_state = TurnState.SPELL_EFFECT
	update_turn_state("SPELL EFFECT")
	Events.spell_effect.emit()
	ready_cnt = 0
	# 应用效果到目标

func end_turn():
	current_turn_state = TurnState.TURN_END
	update_turn_state("TURN END")
	Events.turn_end.emit()
	# 处理回合结束的逻辑，判断游戏状态
	# 若没结束
	# 准备下一个回合
	
	start_player_turn()

func update_turn_state(text):
	turnStage.text = text
	

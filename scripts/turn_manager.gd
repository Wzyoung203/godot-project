extends Node

@onready var turnStage: Label = $TurnStage as Label

signal player_turn
signal effect_trigger
signal effect_resolve
signal turn_end

enum TurnState {
	PLAYER_TURN,
	EFFECT_TRIGGER,
	EFFECT_RESOLVE,
	TURN_END
}

var current_turn_state = TurnState.PLAYER_TURN
# We need two players to finish their respective rounds 
#before moving on to the next stage
var turn_end_count = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_player_turn()
	Events.player_turn_end.connect(end_player_turn)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func end_player_turn():
	if current_turn_state == TurnState.PLAYER_TURN:
		trigger_effects()
		return
	if current_turn_state == TurnState.EFFECT_TRIGGER:
		resolve_effects()
		# 转入魔法生效阶段，按钮禁用，直至下一回合开始
		# $EndTurnButton.disabled = true
		return

func start_player_turn():
	
	current_turn_state = TurnState.PLAYER_TURN
	update_turn_state("PLAYER TURN")
	player_turn.emit()
	# 允许玩家进行操作
	# $EndTurnButton.disabled = false

func trigger_effects():
	current_turn_state = TurnState.EFFECT_TRIGGER
	update_turn_state("EFFECT TRIGGER")
	effect_trigger.emit()
	# 处理玩家和AI的效果发动(在玩家对象中实现)

func resolve_effects():
	current_turn_state = TurnState.EFFECT_RESOLVE
	update_turn_state("EFFECT RESOLVE")
	effect_resolve.emit()
	# 应用效果到目标

func end_turn():
	current_turn_state = TurnState.TURN_END
	update_turn_state("TURN END")
	turn_end.emit()
	# 处理回合结束的逻辑，判断游戏状态
	# 若没结束
	# 准备下一个回合

func update_turn_state(text):
	turnStage.text = text
	

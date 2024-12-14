extends Node

@onready var turn_stage : Label = $TurnStage as Label

signal effect_trigger
enum TurnState {
	PLAYER_TURN,
	EFFECT_TRIGGER,
	EFFECT_RESOLVE,
	TURN_END
}

var current_turn_state = TurnState.PLAYER_TURN

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_player_turn()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func start_player_turn():
	current_turn_state = TurnState.PLAYER_TURN
	update_stage_text("player_turn")	# 显示玩家操作界面
	# 允许玩家进行操作
	# $EndTurnButton.disabled = false

func end_player_turn():
	if current_turn_state == TurnState.PLAYER_TURN:
		trigger_effects()
		return
	if current_turn_state == TurnState.EFFECT_TRIGGER:
		resolve_effects()
		# 转入魔法生效阶段，按钮禁用，直至下一回合开始
		# $EndTurnButton.disabled = true
		return

func trigger_effects():
	current_turn_state = TurnState.EFFECT_TRIGGER
	update_stage_text("Trigger Effects")
	effect_trigger.emit()
	# 处理玩家和AI的效果发动(在玩家对象中实现)

func resolve_effects():
	current_turn_state = TurnState.EFFECT_RESOLVE
	update_stage_text("Resolve Effects")
	# 应用效果到目标

func end_turn():
	current_turn_state = TurnState.TURN_END
	# 处理回合结束的逻辑，判断游戏状态
	# 若没结束
	# 准备下一个回合
	
func update_stage_text(text):
	turn_stage.text = text
	
	

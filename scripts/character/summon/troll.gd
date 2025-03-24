extends Summon
class_name Troll
@onready var Health: Control = $Health
@onready var health_bar: ProgressBar = $Health/HealthBar

# 回合结束时对目标造3点伤害
# 能承受3点伤害
func _ready() -> void:
	max_health = 3
	_damage = 3
	health_bar.max_value = max_health
	super._ready()
	nameID += "_Troll"

func update_health_bar():
	Health.update_health_bar(max_health,health)

func flip():
	$AnimatedSprite2D.flip_h = true

extends Summon
class_name Orge
@onready var Health: Control = $Health
@onready var health_bar: ProgressBar = $Health/HealthBar

# 回合结束时对目标造成两点伤害
# 能承受两点伤害
func _ready() -> void:
	max_health = 2
	_damage = 2
	health_bar.max_value = max_health
	super._ready()
	nameID += "_Orge"

func update_health_bar():
	Health.update_health_bar(max_health,health)

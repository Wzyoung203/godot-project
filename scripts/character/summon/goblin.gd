extends Summon
class_name Goblin
@onready var Health: Control = $Health
@onready var health_bar: ProgressBar = $Health/HealthBar

# 回合结束时对目标造成一点伤害
# 能承受一点伤害
func _ready() -> void:
	max_health = 1
	_damage = 1
	health_bar.max_value = max_health
	super._ready()
	nameID += "_Goblin"

func update_health_bar():
	Health.update_health_bar(max_health,health)

func flip():
	$AnimatedSprite2D.flip_h = true

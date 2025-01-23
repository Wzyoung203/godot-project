extends Summon
class_name Orge
@onready var Health: Control = $Health
@onready var health_bar: ProgressBar = $Health/HealthBar

var _attack_target: Character

# 回合结束时对目标造成两点伤害
# 能承受两点伤害
func _ready() -> void:
	max_health = 2
	health_bar.max_value = max_health
	Events.effect_end.connect(cause_damage)
	super._ready()

func update_health_bar():
	Health.update_health_bar(max_health,health)

func set_controller(caster: Character):
	super.set_controller(caster)
	# print(self,"的主人是:",caster)
func set_attack_target(target:Character):
	_attack_target = target

func cause_damage():
	if _attack_target and !_is_dead:
		_attack_target.take_damage(2)

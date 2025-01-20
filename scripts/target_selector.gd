extends selector

func _ready() -> void:
	Events.selected_spell.connect(_set_spell)
	Events.selected_target.connect(_add_target)
	Events.select_end.connect(spell_effect)


func spell_effect():
	if _target.size()==0:
		Events.effect_end.emit()
		return
	# 让法术生效到目标上
	_spell.apply_effect(_target)
	if _spell is SummonSpell:
		$SummonGenerator.place_creature(_spell.creature)
	
	
	_target.clear()
	Events.effect_end.emit()

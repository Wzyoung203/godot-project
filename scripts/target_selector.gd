extends selector

func _ready() -> void:
	Events.selected_spell.connect(_set_spell)
	Events.selected_target.connect(_add_target)
	Events.select_end.connect(spell_effect)


func spell_effect():
	if _target.size()==0:
		Events.effect_end.emit()
		return
	_spell.apply_effect(_target)
	_target.clear()
	Events.effect_end.emit()

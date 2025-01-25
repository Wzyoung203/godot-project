extends selector
class_name SpellEvent
#func _ready() -> void:
	#Events.selected_spell.connect(_set_spell)
	#Events.selected_target.connect(_add_target)
	#Events.select_end.connect(spell_effect)

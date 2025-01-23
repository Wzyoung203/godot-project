extends selector

@onready var player_generator: Node = $"../PlayerGenerator"
var player1 
var player2 

func _ready() -> void:
	Events.selected_spell.connect(_set_spell)
	Events.selected_target.connect(_add_target)
	Events.select_end.connect(spell_effect)


func spell_effect():
	player1 = player_generator.player_1
	player2 = player_generator.player_2
	if _target.size()==0:
		Events.effect_end.emit()
		return
	# 让法术生效到目标上
	_spell.apply_effect(_target)
	if _spell is SummonSpell:
		if (_spell.caster == player1):
			$SummonGenerator.place_creature(_spell.creature)
			print(_spell.creature)
	
	
	_target.clear()
	Events.effect_end.emit()

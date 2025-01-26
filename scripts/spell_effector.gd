extends Node2D

var spellEvents:Array[SpellEvent]
var currentSpellEvent:SpellEvent
@onready var player_generator: Node = $"../PlayerGenerator"
var player1
var player2


func _ready() -> void:
	Events.selected_spell.connect(create_new_spell_event)
	Events.selected_target.connect(add_target_to_spell_event)
	
	Events.spell_effect.connect(spell_effect)

func create_new_spell_event(spell:Spell):
	currentSpellEvent = SpellEvent.new()
	currentSpellEvent._set_spell(spell)
	currentSpellEvent.set_caster(player_generator.player_1)

func add_target_to_spell_event(character: Character):
	currentSpellEvent._add_target(character)
	spellEvents.append(currentSpellEvent)
	Events.event_creat_success.emit()
	
func spell_effect():
	if spellEvents.size() == 0:
		Events.effect_end.emit()
		return
	for spellEvent in spellEvents:
		var _spell = spellEvent._spell
		var _target = spellEvent._target
		#print(_spell,"  ",_target)
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
	Events.effect_end.emit()
	spellEvents.clear()

extends Node2D

var spellEvents:Array[SpellEvent]
var currentSpellEvent:SpellEvent
@onready var player_generator: Node = $"../PlayerGenerator"
@onready var character_manager: Node2D = $"../CharacterManager"
var player1:PlayerHuman
var player2:PlayerAI

func _ready() -> void:
	Events.selected_spell.connect(create_new_spell_event)
	Events.selected_target.connect(add_target_to_spell_event)
	
	Events.spell_effect.connect(spell_effect)
	
	Events.ai_cur_spells_targets.connect(create_ai_spell_event)
	
	Events.player_turn_end.connect(remove_enhancements)
	
func create_new_spell_event(spell:Spell):
	currentSpellEvent = SpellEvent.new()
	currentSpellEvent._set_spell(spell)
	currentSpellEvent.set_caster(player_generator.player_1)
func create_ai_spell_event(spells:Array[Spell],targets:Array[Role]):
	
	if spells.size() != targets.size():
		print("ERROR: spell and targets doesn't match.")
		return
	if spells.size() == 0:
		Events.ai_events_created.emit()
		return
	for i in spells.size():
		var event:SpellEvent = SpellEvent.new()
		event.set_caster(player_generator.player_2)
		event._set_spell(spells[i])
		event._add_target(targets[i])
		if event._spell is Sheild:
			spellEvents.push_front(event)
		else:
			spellEvents.append(event)
	Events.ai_events_created.emit()
	
func add_target_to_spell_event(character: Role):
	currentSpellEvent._add_target(character)
	if currentSpellEvent._spell is Sheild:
		spellEvents.push_front(currentSpellEvent)
	else:
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
		if _spell is FireStorm:
			_target = $"../CharacterManager".creatures
		_spell.apply_effect(_target)
		
		if _spell is Disease:
			if (_spell.caster == player2):
				Game_Status.set_p1_is_disease(6)
			else:
				Game_Status.set_p2_is_disease(6)
		if _spell is CureHeavyWounds:
			if (_spell.caster == player2):
				Game_Status.set_p2_is_disease(0)
			else:
				Game_Status.set_p1_is_disease(0)
		if _spell is SummonSpell:
			if (_spell.caster == player1):
				_spell.creature.set_controller(player1)
				$SummonGenerator.place_creature(_spell.creature)
				Game_Status.add_p1_creatures_attacks(_spell.creature.get_damage())
				character_manager.add_creature(_spell.creature)
			if (_spell.caster == player2):
				_spell.creature.set_controller(player2)
				$SummonGenerator2.place_creature(_spell.creature)
				Game_Status.set_p2_creatures_attacks(_spell.creature.get_damage())
				character_manager.add_creature(_spell.creature)
	Events.effect_end.emit()
	spellEvents.clear()

func remove_enhancements():
	player_generator.player_1.hasSheild = false
	player_generator.player_2.hasSheild = false

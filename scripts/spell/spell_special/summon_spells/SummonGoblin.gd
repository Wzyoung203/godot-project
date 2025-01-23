extends SummonSpell
class_name SummonGoblin

var creature_scene = preload("res://scenes/characters/goblin.tscn")

func _init():
	super("Summon Goblin","sfw","This spell creates a goblin under the control of the subject upon whom the spell is cast,The goblin can attack immediately and its victim can be any any wizard or other monster the controller desires, stating which at the time he writes his gestures. It does 1 point of damage to its victim per turn and is destroyed after 1 point of damage is inflicted upon it.")

func apply_effect(Targets: Array = []):
	super(Targets)
	creature.set_attack_target(Targets[0])

func creat_creature(caster:Character):
	creature = creature_scene.instantiate()
	creature.set_controller(caster)

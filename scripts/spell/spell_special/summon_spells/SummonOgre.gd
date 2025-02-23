extends SummonSpell
class_name SummonOgre

var creature_scene = preload("res://scenes/characters/Ogre.tscn")

func _init():
	super("Summon Ogre","psfw","This spell is the same as 'summon goblin' but the ogre created inflicts and is destroyed by 2 points of damage rather than 1.")

func apply_effect(Targets: Array = []):
	super(Targets)
	creature.set_attack_target(Targets[0])

func creat_creature(caster:Role):
	creature = creature_scene.instantiate()
	creature.set_controller(caster)

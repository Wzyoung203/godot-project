extends Spell
class_name SummonSpell

var creature:Summon

func _init(name: String, sequences: String, effect: String):
	super(name, sequences, effect)

func apply_effect(Targets: Array = []):
	return creat_creature()

func creat_creature():
	pass

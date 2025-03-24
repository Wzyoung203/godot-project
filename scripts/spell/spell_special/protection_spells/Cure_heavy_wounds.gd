extends ProtectionSpell
class_name CureHeavyWounds

func _init():
	super("CureHeavyWounds","dfpw","This spell is the same as 'cure light wounds' for its effect, but 2 points of damage are cured instead of 1, or only 1 if only 1 had been sustained. A side effect is that the spell will also cure a disease (note 'raise dead' on a live individual won't). ")

func apply_effect(Targets: Array[Role] = []):
	for target in Targets:
		target.heal(2)
		target._disease_cnt = -1

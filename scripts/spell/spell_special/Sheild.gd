extends ProtectionSpell
class_name Sheild

func _init():
	super("Sheild","p","This spell protects the subject from all attacks from monsters (that is, creatures created by a summons class spell), from missile spells, and from stabs by wizards. The shield lasts for that turn only, but one shield will cover all such attacks made against the subject that turn.")

func apply_effect():
	super.apply_effect()

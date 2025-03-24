extends ProtectionSpell
class_name CureLightWounds

func _init():
	super("CureLightWounds","dfw","If the subject has received damage then he is cured by 1 point as if that point had not been inflicted. ")

func apply_effect(Targets: Array[Role] = []):
	for target in Targets:
		target.heal(1)

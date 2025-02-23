extends DamagingSpell
class_name FingerOfDeath
func _init():
	super("Finger Of Death","pwpfsssd","Kills the subject stone dead. This spell is so powerful that it is unaffected by a 'counter-spell' although a 'dispel magic' spell cast upon the final gesture will stop it.")

var damage = 0

func apply_effect(Targets: Array[Role] = []):
	for target in Targets:
		target.take_damage(target.health)
	

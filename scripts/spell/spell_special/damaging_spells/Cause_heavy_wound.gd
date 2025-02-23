extends DamagingSpell
class_name CauseHeavyWound
func _init():
	super("Cause Heavy Wound","wpfd","The subject of this spell is inflicted with 3 points of damage.")
var damage = 3

func apply_effect(Targets: Array[Role] = []):
	for target in Targets:
		target.take_damage(damage)
	

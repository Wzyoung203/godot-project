extends DamagingSpell
class_name CauseLightWound
func _init():
	super("Cause Light Wound","wfp","The subject of this spell is inflicted with 2 points of damage.")
var damage = 2

func apply_effect(Targets: Array[Role] = []):
	for target in Targets:
		target.take_damage(damage)
	

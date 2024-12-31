extends DamagingSpell
class_name Missile
func _init():
	super("Missile","sd","Cause 1 point of damage to the target. The spell is thwarted by a 'shield' in addition to the usual 'counter-spell', 'dispel magic' and 'magic mirror' (the latter causing it to hit whoever cast it instead).")

var damage = 1

func apply_effect(Targets: Array[Character] = []):
	for target in Targets:
		target.take_damage(damage)
	

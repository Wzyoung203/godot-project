extends DamagingSpell
class_name FireBall
func _init():
	super("Fire Ball","fssdd","The subject of this spell is hit by a ball of fire and sustains 5 points of damage unless he is resistant to fire. If at the same time an 'ice storm' prevails, the subject of the 'fireball' is instead not harmed by either spell, although the storm will affect others as normal. If directed at an ice elemental, the fireball will destroy it before it can attack, but has no other effect on the creatures.")
var damage = 5

func apply_effect(Targets: Array[Character] = []):
	for target in Targets:
		target.take_damage(damage)
	

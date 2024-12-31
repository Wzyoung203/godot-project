extends DamagingSpell
class_name LightningBolt
func _init():
	super("Lightning Bolt","dffdd","The subject of this spell is hit by a bolt of lightning and sustains 5 points of damage")

var damage = 5

func apply_effect(Targets: Array[Character] = []):
	for target in Targets:
		target.take_damage(damage)
	

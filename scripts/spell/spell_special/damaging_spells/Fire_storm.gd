extends DamagingSpell
class_name FireStorm

func _init():
	super("Fire Storm","swwC","Everything not resistant to heat sustains 5 points of damage that turn. The spell cancels wholly, causing no damage, with either an 'ice storm' or an ice elemental. It will destroy but not be destroyed by a fire elemental. Two 'fire storms' act as one.")
var damage = 5

func apply_effect(Targets: Array[Role] = []):
	for target in Targets:
		target.take_damage(damage)
	

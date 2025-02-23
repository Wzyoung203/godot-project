extends Role
class_name Player

func _ready() -> void:
	max_health = 14
	nameID = "Player"
	super._ready()

func die():
	print(self.get_class," has died.")

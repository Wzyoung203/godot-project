extends Character
class_name Summon

var _is_dead:bool

func _ready() -> void:
	super._ready()

func die():
	_is_dead = true 
	print(self.get_class," has died.")

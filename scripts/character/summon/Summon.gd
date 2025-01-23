extends Character
class_name Summon

var _is_dead:bool
var _controller:Character

func _ready() -> void:
	super._ready()

func die():
	_is_dead = true 
	print("Summon has died.")

func set_controller(charcter:Character):
	_controller = charcter
	print(_controller)

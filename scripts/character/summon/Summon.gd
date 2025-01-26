extends Character
class_name Summon

var _is_dead:bool
var _controller:Character
var _attack_target: Character
var _damage
func _ready() -> void:
	super._ready()
	Events.effect_end.connect(cause_damage)
	nameID = "Summon"

func die():
	_is_dead = true 
	print("Summon has died.")

func set_controller(charcter:Character):
	_controller = charcter
	print(_controller)

func set_attack_target(target:Character):
	_attack_target = target

func cause_damage():
	if _attack_target and !_is_dead:
		_attack_target.take_damage(_damage)
		var message = nameID+" cause "+str(_damage)+" to "+_attack_target.nameID
		Events.normal_event.emit(message)

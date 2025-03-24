extends Role
class_name Summon

var _is_dead:bool
var _controller:Role
var _attack_target: Role
var _damage: int
func _ready() -> void:
	super._ready()
	Events.effect_end.connect(cause_damage)
	nameID = "Summon"

func die():
	_is_dead = true 
	print("Summon has died.")

func set_controller(charcter:Role):
	_controller = charcter

func set_attack_target(target:Role):
	_attack_target = target

func get_damage():
	return _damage

func cause_damage():
	if _attack_target and !_is_dead:
		if !_attack_target.hasSheild:
			_attack_target.take_damage(_damage)
			var message = nameID+" cause "+str(_damage)+"damage to "+_attack_target.nameID
			Events.normal_event.emit(message)

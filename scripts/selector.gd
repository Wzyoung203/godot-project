extends Node2D
class_name selector

var _spell: Spell
var _caster: Role
var _target: Array[Role] = []

func set_caster(caster:Role):
	_caster=caster

# 判断施法对象是否合法
func _is_leggal() -> bool:
	return true

func _set_spell(spell:Spell):
	if _spell==null:
		_spell = spell

func _set_target(target: Array[Role]):
	_target = target

func _add_target(target:Role):
	if _target.size() == 0:
		_target.append(target)
	

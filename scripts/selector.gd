extends Node2D
class_name selector

var _spell: Spell
var _caster: Character
var _target: Array[Character] = []

func set_caster(caster:Character):
	_caster=caster

# 判断施法对象是否合法
func _is_leggal() -> bool:
	return true

func _set_spell(spell:Spell):
	if _spell==null:
		_spell = spell

func _set_target(target: Array[Character]):
	_target = target

func _add_target(target:Character):
	if _target.size() == 0:
		_target.append(target)
	

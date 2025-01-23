extends Node2D
class_name selector

var _spell: Spell
var _caster: Character
var _target: Array[Character] = []

# 判断施法对象是否合法
func _is_leggal() -> bool:
	return true

func _set_spell(spell:Spell):
	_spell = spell

func _add_target(target:Character):
	_target.append(target)
	

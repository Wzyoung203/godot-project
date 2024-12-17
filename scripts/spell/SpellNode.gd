class_name SpellNode
# A node in the dictionary tree
var _value: String
var _isSpell: bool
var _children: Array[SpellNode]
var _parent: SpellNode
var _spell: Spell

func _init(value: String = "",isSpell: bool = false,children: Array[SpellNode] = [],parent: SpellNode = null,spell: Spell=null):
	_value = value
	_isSpell = isSpell
	_children = children
	_parent = parent
	_spell = spell

func add_child(child: SpellNode):
	_children.append(child)
#
#func check_child_exist(char: String) -> bool:
	#for child in _children:
		#if char == child.get_value():
			#return true
	#return false

func get_child(char: String) -> SpellNode:
	for child in _children:
		if char == child.get_value():
			return child
	return null

func get_value() -> String:
	return _value

func get_is_spell() -> bool:
	return _isSpell

func get_children() -> Array:
	return _children
func get_children_value() -> Array:
	var children_name = []
	for _child in _children:
		children_name.append(_child.get_value())
	return children_name

func get_parent() -> SpellNode:
	return _parent

func get_spell() -> Spell:
	return _spell

func set_value(new_value: String) -> void:
	_value = new_value

func set_is_spell(new_is_spell: bool) -> void:
	_isSpell = new_is_spell

func set_spell(new_spell: Spell) -> void:
	_spell = new_spell

func set_children(new_children: Array) -> void:
	_children = new_children

func set_parent(new_parent: SpellNode) -> void:
	_parent = new_parent

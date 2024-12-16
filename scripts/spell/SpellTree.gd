class_name SpellTree
# 存储法术的字典树
var root: SpellNode
var spells: Array

func _init():
	self.creat_spell_tree()
func creat_spell_tree():
	root = SpellNode.new()
	add_spell("p",Sheild.new(),root)
	add_spell("sfe",Sheild.new(),root)
	add_spell("pa",Sheild.new(),root)
	add_spell("pfe",Sheild.new(),root)
	
	
	
	
# 添加法术到字典树中
func add_spell(sequence: String, spell: Spell, node: SpellNode):
	if len(sequence) == 0:
		return
	
	var char = sequence[0]
	var child = node.get_child(char)
	if !child:
		var parent = node
		if len(sequence) == 1:
			var isSpell = true
			var newNode = SpellNode.new(char,isSpell,[],parent,spell)
			node.add_child(newNode)
			child = newNode
		else:
			var isSpell = false
			var newNode = SpellNode.new(char,isSpell,[],parent,null)
			node.add_child(newNode)
			child = newNode
	var substring = sequence.substr(1)
	add_spell(substring,spell,child)

# 遍历字典树，发现所有法术
func print_trie(node: SpellNode = root, prefix: String = "") -> void:
	if node == null:
		return
	
	for child in node._children:
		print_trie(child, prefix + child._value)
	if node._isSpell:
		spells.append(prefix)

func print_spells():
	print(spells)	

# 根据已有的法术树，搜索输入序列：是法术返回该法术，不是则返回空
func search(sequence: String) -> Spell:
	var currentNode = root
	for char in sequence:
		if currentNode.get_child(char):		currentNode = currentNode.get_child(char)
		else:	 
				#print("Sesarch failed: The seq is not in tree")
				return null
	if currentNode.get_is_spell():
		#print("Sesarch success")
		return currentNode.get_spell()
	else:
		#print("Sesarch failed: The seq is not a spell")
		return null	
		
		
		
		

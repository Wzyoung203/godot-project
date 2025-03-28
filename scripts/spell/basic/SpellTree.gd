extends Node 
class_name SpellTree
# 存储法术的字典树
var root: SpellNode
var spells: Array

var spellList: Array[Spell]

func _init():
	self.creat_spell_tree()
	self.preload_trie()
	self.print_spells()

func creat_spell_tree():
	root = SpellNode.new()
	add_spell("p",Sheild.new(),root)

	add_spell("sd",Missile.new(),root)
	add_spell("pwpfsssd",FingerOfDeath.new(),root)
	add_spell("dffdd",LightningBolt.new(),root)
	add_spell("wfp",CauseLightWound.new(),root)
	add_spell("wpfd",CauseHeavyWound.new(),root)
	add_spell("fssdd",FireBall.new(),root)
	
	add_spell("sfw",SummonGoblin.new(),root)
	add_spell("psfw",SummonOgre.new(),root)
	add_spell("fpsfw",SummonTroll.new(),root)
	add_spell("wfpsfw",SummonGaint.new(),root)

	add_spell("dsfffC",Disease.new(),root)
	add_spell("dfw",CureLightWounds.new(),root)
	add_spell("dfpw",CureHeavyWounds.new(),root)
	
	add_spell("swwC",FireStorm.new(),root)
	#
	#add_spell("w",SummonGoblin.new(),root)
	#add_spell("sppp",Sheild.new(),root)
	#add_spell("fs",Sheild.new(),root)
	#add_spell("s",Missile.new(),root)
	#add_spell("pfsf",Sheild.new(),root)
	#add_spell("spppf",Sheild.new(),root)
	#add_spell("fsf",Sheild.new(),root)
	#add_spell("sff",Missile.new(),root)
	
	
	
	
	
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
	else:
		if len(sequence) == 1:
			child.set_is_spell(true)
			child.set_spell(spell)
	var substring = sequence.substr(1)
	add_spell(substring,spell,child)

# 遍历字典树，发现所有法术
func preload_trie(node: SpellNode = root, prefix: String = "") -> void:
	if node == null:
		return
	
	for child in node._children:
		preload_trie(child, prefix + child._value)
	if node._isSpell:
		spells.append(prefix)
		var spell = node.get_spell()
		spellList.append(spell)

func print_spells():
	print("法术数据库加载完成:")
	print(spells)

# 根据已有的法术树，搜索输入序列：是法术返回该法术，不是则返回空
func search(sequence: String, currentNode: SpellNode) -> Spell:
	var char = sequence[0]
	if currentNode.get_child(char):
		currentNode = currentNode.get_child(char)
	else:
		return null
	if len(sequence)==1:
		if currentNode.get_is_spell():
			return currentNode.get_spell()
		else:
			return null
	else:	 
		#print("Sesarch failed: The seq is not in tree")
		return search(sequence.substr(1),currentNode)

# 根据输入历史查找可使用的法术
func search_valid_spells(sequence: String) -> Array[Spell]:
	var valid_spells: Array[Spell] = []
	while sequence.length() > 0:
		# 按大写（双手手势）搜索
		if search(sequence,root):
			valid_spells.append(search(sequence,root))
		sequence = sequence.substr(1)
	#if valid_spells.size() > 0:
		#print("找到了法术！")
		#for spell in valid_spells:
			#print(spell.getName())
	return valid_spells

# 根据特定序列查找法术
func search_in_spell_list(sequence: String) -> Spell:
	for spell in spellList:
		if spell.sequences == sequence:
			return spell
	return null		

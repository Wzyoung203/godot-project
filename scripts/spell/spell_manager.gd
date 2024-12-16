extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var STree = SpellTree.new()
	print("法术数据库加载完成：")
	STree.print_trie()
	STree.print_spells()
	STree.search("pe")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

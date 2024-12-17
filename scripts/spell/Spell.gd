class_name Spell

var name: String
var sequences: String
var effect: String

func _init(name: String, sequences: String, effect: String):
	self.name = name
	self.sequences = sequences
	self.effect = effect

# 返回法术的基本信息
func getInfo():
	var info = self.name+": "
	for sequence in self.sequences:
		info += sequence
	return  info
func getEffect():
	self.effect = effect	
func getName():
	return name
func cast():
	print("Casting: ", name)
	# 基类效果应用逻辑，可以被子类覆盖
	apply_effect()

func apply_effect():
	# 这里可以添加一些通用的效果应用逻辑
	print("Applying effect: ", effect)

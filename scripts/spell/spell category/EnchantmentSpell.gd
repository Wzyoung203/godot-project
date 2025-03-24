extends Spell
class_name EnchantmentSpell

func _init(name: String, sequences: String, effect: String):
	super(name, sequences, effect)

# 生效回合数计时
var effect_cnt : int

func apply_effect(Targets: Array = []):
	# 覆盖基类的方法，添加防护法术特有的效果
	print("Applying damaging effect: ", effect)
	# 可以添加更多具体的逻辑

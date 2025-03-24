extends EnchantmentSpell
class_name Disease
func _init():
	super("Disease","dsfffC","The subject of this spell immediately contracts a deadly (non-contagious) disease which will kill him at the end of 6 turns counting from the one upon which the spell is cast. The malady is cured by 'remove enchantment' or 'cure heavy wounds' or 'dispel magic' in the meantime.")
	effect_cnt = 6


func apply_effect(Targets: Array[Role] = []):
	for target in Targets:
		target.set_disease(effect_cnt)
	

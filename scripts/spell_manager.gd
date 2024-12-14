extends Node2D

var spell_library = {
	"Shield": ProtectionSpell.new("Shield", ["p"], "This spell protects the subject from all attacks from monsters (that is, creatures created by a summons class spell), from missile spells, and from stabs by wizards. The shield lasts for that turn only, but one shield will cover all such attacks made against the subject that turn."),
	"Remove enchantment": ProtectionSpell.new("Remove enchantment", ["pdwd"],"If the subject of this spell is currently being effected by any of the spells in the spells in the 'enchantments' section, and/or if spells from that section are cast at him at the same time as the remove enchantment, then any such spells terminate immediately although their effect for that turn might already have passed. A second effect of the spell is to destroy any monster upon which it is cast, although the monster can attack in that turn. It does not affect wizards unless cast on a wizard as he creates a monster when the monster is destroyed, and the effects described above apply."),
	"Magic Mirror": ProtectionSpell.new("Magic Mirror", ["cW"], "Any spell cast at the subject of this spell is reflected back at the caster of that spell for that turn only. This includes spells like 'missile' and 'lightning bolt' but does not include attacks by monsters already in existence, or stabs from wizards."),
	"Counter-spell": ProtectionSpell.new("Counter-spell", ["wws","wpp"], "Any other spell cast upon the subject in the same turn has no effect whatever.The 'counter-spell' will cancel all the spells cast at the subject for that turn including 'remove enchantment' and 'magic mirror' but not 'dispel magic' or 'finger of death'."),
	"Dispel Magic": ProtectionSpell.new("Dispel Magic", ["cdpw"], "This spell acts as a combination of 'counter-spell' and 'remove enchantment', but its effects are universal rather than limited to the subject of the spell."),
	"Raise Dead": ProtectionSpell.new("Raise Dead", ["dwwfwc"], "The subject of this spell is usually a recently-dead (not yet decomposing) human corpse though it may be used on a dead monster."),
	"Cure Light Wounds": ProtectionSpell.new("Cure Light Wounds", ["dfw"], "If the subject has received damage then he is cured by 1 point as if that point had not been inflicted."),
	"Cure Heavy Wounds": ProtectionSpell.new("Cure Heavy Wounds", ["dfpw"], "This spell is the same as 'cure light wounds' for its effect, but 2 points of damage are cured instead of 1, or only 1 if only 1 had been sustained."),
}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("法术数据库加载完成：")
	for spell_name in spell_library:
		var spell = spell_library[spell_name]
		print(spell.getInfo())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

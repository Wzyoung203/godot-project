extends Panel
@onready var spell_effector: Node2D = $"../SpellEffector"
@onready var vbox: VBoxContainer = $ScrollContainer/BoxContainer
var cnt=0
func _ready() -> void:
	Events.effect_end.connect(spell_event_record)
	Events.normal_event.connect(creature_event_record)

func spell_event_record():
	
	var events:Array[SpellEvent] = spell_effector.spellEvents
	for event in events:
		var caster = event._caster.nameID
		var spell = event._spell.getName()
		var target:Array[String]
		for i in range(len(event._target)):
			target.append(event._target[i].nameID)
		var label = Label.new()
		label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		label.autowrap_mode = TextServer.AUTOWRAP_WORD
		label.text = str(caster) +" cast "+ str(spell) + " to "+ str(target)
		
		vbox.add_child(label)

func creature_event_record(message: String):
	var label = Label.new()
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label.autowrap_mode = TextServer.AUTOWRAP_WORD
	label.text = message
	vbox.add_child(label)
	

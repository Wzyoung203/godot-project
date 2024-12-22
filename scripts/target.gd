extends Panel

func _ready() -> void:
	self.mouse_filter = Control.MOUSE_FILTER_IGNORE
	Events.selected_spell.connect(start_monitoring_events)
	Events.selected_target.connect(stop_monitoring_events)
	

func start_monitoring_events(spell:Spell):
	self.mouse_filter = Control.MOUSE_FILTER_STOP
func stop_monitoring_events(charcter:Character):
	self.mouse_filter = Control.MOUSE_FILTER_IGNORE

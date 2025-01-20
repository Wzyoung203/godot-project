extends Control

@onready var information: Label = $information
@onready var timer: Timer = $Timer

func _ready() -> void:
	showInfo("ready")
	Events.no_valid_spell.connect(showInfo_NVS)

func showInfo(notice: String):
	self.visible = true
	information.text = notice
	timer.start()
func showInfo_NVS():
	showInfo("NO Vaild Spell")
	Events.select_end.emit()
func _on_timer_timeout() -> void:
	information.text = ""
	self.visible = false
	timer.stop()

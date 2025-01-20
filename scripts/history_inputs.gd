extends Control

@onready var panel: Panel = $Panel

func _on_button_pressed() -> void:
	panel.visible = !panel.visible

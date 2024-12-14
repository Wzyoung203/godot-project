extends Node


var DISTANCE_TO_SCREEN_EDGE = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var player = get_child(0)

	var screen_size = get_viewport().get_visible_rect().size
	player.position = Vector2(DISTANCE_TO_SCREEN_EDGE, screen_size.y / 2)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func start():
	pass

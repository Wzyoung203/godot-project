extends Node

@onready var start_position1 = $StartPosition1
@onready var start_position2 = $StartPosition2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func start():
	var PLAYER_HUMAN = preload("res://scenes/player_human.tscn")
	var player_1 = PLAYER_HUMAN.instantiate()
	add_child(player_1)
	player_1.position = start_position1.global_position
	
	var PLAYER_AI = preload("res://scenes/player_AI.tscn")
	var player_2 = PLAYER_AI.instantiate()
	add_child(player_2)
	player_2.position = start_position2.global_position
	player_2.flip()

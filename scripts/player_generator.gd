extends Node

@onready var start_position1 = $StartPosition1
@onready var start_position2 = $StartPosition2
@onready var character_manager: Node2D = $"../CharacterManager"
var player_1:PlayerHuman
var player_2:PlayerAI
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Events.creature_changed.connect(ai_target_modify)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func start():
	var PLAYER_HUMAN = preload("res://scenes/characters/player_human.tscn")
	player_1 = PLAYER_HUMAN.instantiate()
	add_child(player_1)
	player_1.position = start_position1.global_position
	
	var PLAYER_AI = preload("res://scenes/characters/player_AI.tscn")
	player_2 = PLAYER_AI.instantiate()
	add_child(player_2)
	player_2.position = start_position2.global_position
	player_2.flip()
	
	character_manager.add_creature(player_1)
	character_manager.add_creature(player_2)

func ai_target_modify(creatures:Array[Character]):
	player_2.set_targets(creatures)

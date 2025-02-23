extends Player
class_name PlayerHuman
@onready var Health: Control = $Health

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("player")
	super._ready()
	nameID += "_human"

func update_health_bar():
	Health.update_health_bar(max_health,health)
	Game_Status.set_p1_hp(health)
	
func flip():
	$AnimatedSprite2D.flip_h = true
	

extends Player
class_name PlayerHuman
@onready var Health: Control = $Health

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func update_health_bar():
	Health.update_health_bar(max_health,health)
	
func flip():
	$AnimatedSprite2D.flip_h = true
	

extends Player

@onready var health_bar: ProgressBar = $HealthBar
signal player_turn_end
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func update_health_bar():
	health_bar.update_health_bar(max_health,health)

func turn_end():
	player_turn_end.emit()
	#print("玩家回合结束")
	
func flip():
	$AnimatedSprite2D.flip_h = true	

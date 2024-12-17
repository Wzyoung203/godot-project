extends Player

@onready var health_bar = $HealthBar
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func update_health_bar():
	var fill = health_bar.get_theme_stylebox("fill")
	health_bar.value = health
	fill.bg_color = Color(0,1,0)
	if health <= max_health/2:	
		fill.bg_color = Color(1,1,0)
	if health <= max_health/4:
		fill.bg_color = Color(1,0,0)
	
func flip():
	$AnimatedSprite2D.flip_h = true
	

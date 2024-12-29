extends Control
@onready var health_text: Label = $HealthText
@onready var health_bar: ProgressBar = $HealthBar
func update_health_bar(max_health:int,health:int):
	health_text.text = "%s/%s" % [str(health),str(max_health)]
	var fill = health_bar.get_theme_stylebox("fill")
	var new_fill = fill.duplicate()
	health_bar.value = health
	new_fill.bg_color = Color(0,1,0)
	if health <= max_health/2:	
		new_fill.bg_color = Color(1,1,0)
		health_bar.add_theme_stylebox_override("fill",new_fill)
	if health <= max_health/4:
		new_fill.bg_color = Color(1,0,0)
		health_bar.add_theme_stylebox_override("fill",new_fill)
	

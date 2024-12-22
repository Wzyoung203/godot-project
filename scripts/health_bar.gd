extends ProgressBar
func update_health_bar(max_health:int,health:int):
	var fill = get_theme_stylebox("fill")
	var new_fill = fill.duplicate()
	value = health
	new_fill.bg_color = Color(0,1,0)
	if health <= max_health/2:	
		new_fill.bg_color = Color(1,1,0)
		self.add_theme_stylebox_override("fill",new_fill)
	if health <= max_health/4:
		new_fill.bg_color = Color(1,0,0)
		self.add_theme_stylebox_override("fill",new_fill)
	

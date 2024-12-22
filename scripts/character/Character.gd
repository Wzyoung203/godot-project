extends Area2D
class_name Character

var health: int  
var max_health: int  

func _ready():
	health = max_health
	update_health_bar()

func take_damage(damage: int):
	self.health -= damage

	if self.health <= 0:
		self.health = 0
		die()
	update_health_bar()

func heal(amount: int):
	self.health += amount
	if self.health > max_health:
		self.health = max_health
	update_health_bar()
	

func die():
	print("Character has died.")

func update_health_bar():
	pass

func _area_exited():
	var cursor = load("res://cursor/PNG/Basic/Default/pointer_c.png")
	Input.set_custom_mouse_cursor(cursor)

func _area_selected(event: InputEvent):
	var cursor = load("res://cursor/PNG/Basic/Default/target_round_b.png")
	Input.set_custom_mouse_cursor(cursor)
	if event is InputEventMouseButton and event.pressed:
		_selected_target()


func _selected_target():
	print("选择角色：",self)
	Events.selected_target.emit(self)
	Events.select_end.emit()

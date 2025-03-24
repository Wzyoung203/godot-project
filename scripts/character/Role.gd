extends Area2D
class_name Role

var health: int  
var max_health: int  
var nameID: String

var hasSheild: bool
var _disease_cnt: int = -1

func _ready():
	health = max_health
	update_health_bar()
	Events.turn_end.connect(disease_cnt_decrease)

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
	print("Role has died.")

func update_health_bar():
	pass

func _area_exited():
	var cursor = load("res://adon/cursor/PNG/Basic/Default/cursor_none.png")
	Input.set_custom_mouse_cursor(cursor)
func _area_entered():
	var cursor = load("res://adon/cursor/PNG/Basic/Default/cursor_none.png")
	Input.set_custom_mouse_cursor(cursor)
func _area_selected(event: InputEvent):
	var cursor = load("res://adon/cursor/PNG/Basic/Default/target_round_b.png")
	Input.set_custom_mouse_cursor(cursor)
	if event is InputEventMouseButton and event.pressed:
		_selected_target()


func _selected_target():
	#print("选择角色：",self)
	Events.selected_target.emit(self)

func set_sheild(has_sheld:bool):
	self.hasSheild = has_sheld

func set_disease(disease_cnt:int):
	if _disease_cnt == -1:
		_disease_cnt = disease_cnt

func disease_cnt_decrease():
	if _disease_cnt > -1:
		_disease_cnt -= 1
	if _disease_cnt == 0:
		self.take_damage(self.health)
	

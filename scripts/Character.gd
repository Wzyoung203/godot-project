extends Area2D
class_name Character

var health: int  
var max_health: int  

func _ready():
	self.max_health = max_health
	self.health = max_health
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

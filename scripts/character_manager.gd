extends Node2D
var creatures:Array[Role]

func add_creature(character:Role):
	creatures.append(character)
	Events.creature_changed.emit(creatures)

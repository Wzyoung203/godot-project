extends Node2D
var creatures:Array[Character]

func add_creature(character:Character):
	creatures.append(character)
	Events.creature_changed.emit(creatures)

extends Node
@onready var ps1: Marker2D = $Position1
@onready var ps2: Marker2D = $Position2
@onready var ps3: Marker2D = $Position3
@onready var ps4: Marker2D = $Position4
@onready var ps5: Marker2D = $Position5
@onready var ps6: Marker2D = $Position6

func place_creature(creature:Node2D):
	add_child(creature)
	creature.position = ps1.global_position

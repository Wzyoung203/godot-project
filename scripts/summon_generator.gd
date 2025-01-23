extends Node
@onready var ps1: Marker2D = $Position1
@onready var ps2: Marker2D = $Position2
@onready var ps3: Marker2D = $Position3
@onready var ps4: Marker2D = $Position4
@onready var ps5: Marker2D = $Position5
@onready var ps6: Marker2D = $Position6
var ps_list:Array
var flag = 0

func _ready():
	ps_list.append(ps1)
	ps_list.append(ps2)
	ps_list.append(ps3)
	ps_list.append(ps4)
	ps_list.append(ps5)
	ps_list.append(ps6)

func place_creature(creature:Node2D):
	if (flag <6):
		add_child(creature)
		creature.position = ps_list[flag].global_position
		flag = flag+1

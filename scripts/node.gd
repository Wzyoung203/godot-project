extends Node



func _ready() -> void:
	var my_csharp_script = load("res://scripts/CSscripts/MyCSharpScript.cs")
	var my_csharp_node = my_csharp_script.new()
	my_csharp_node.SayHello("Piter")

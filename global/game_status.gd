extends Node
class_name GameStatus

var _p1_left_hand: String
var _p1_right_hand: String
var _p1_hp: int
var _p1_creatures_attacks: int

var _p2_left_hand: String
var _p2_right_hand: String
var _p2_hp: int
var _p2_creatures_attacks: int

func _to_string() -> String:
	var result = ""
	result += "Left Hand: " + _p1_left_hand + "\n"
	result += "Right Hand: " + _p1_right_hand + "\n"
	result += "HP: " + str(_p1_hp) + "\n"
	result += "Creatures Attacks: " + str(_p1_creatures_attacks) + "\n"

	result += "Left Hand: " + _p2_left_hand + "\n"
	result += "Right Hand: " + _p2_right_hand + "\n"
	result += "HP: " + str(_p2_hp) + "\n"
	result += "Creatures Attacks: " + str(_p2_creatures_attacks) + "\n"

	return result

# Player 1
func get_p1_left_hand() -> String:
	return _p1_left_hand

func set_p1_left_hand(value: String) -> void:
	_p1_left_hand = value

func get_p1_right_hand() -> String:
	return _p1_right_hand

func set_p1_right_hand(value: String) -> void:
	_p1_right_hand = value

func get_p1_hp() -> int:
	return _p1_hp

func set_p1_hp(value: int) -> void:
	_p1_hp = value

func get_p1_creatures_attacks() -> int:
	return _p1_creatures_attacks

func set_p1_creatures_attacks(value: int) -> void:
	_p1_creatures_attacks = value

# Player 2
func get_p2_left_hand() -> String:
	return _p2_left_hand

func set_p2_left_hand(value: String) -> void:
	_p2_left_hand = value

func get_p2_right_hand() -> String:
	return _p2_right_hand

func set_p2_right_hand(value: String) -> void:
	_p2_right_hand = value

func get_p2_hp() -> int:
	return _p2_hp

func set_p2_hp(value: int) -> void:
	_p2_hp = value

func get_p2_creatures_attacks() -> int:
	return _p2_creatures_attacks

func set_p2_creatures_attacks(value: int) -> void:
	_p2_creatures_attacks = value

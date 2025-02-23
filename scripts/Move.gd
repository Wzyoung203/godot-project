class_name Move
var _left_hand:String
var _right_hand:String
var _left_spell:String
var _left_target:int
var _right_spell:String # spell sequence
var _right_target:int # null -1, targets[i] i

func _init(left_hand,right_hand,left_spell,left_target,right_spell,right_target) -> void:
	_left_hand=left_hand
	_right_hand=right_hand
	_left_spell=left_spell
	_left_target=left_target
	_right_spell=right_spell
	_right_target=right_target
	
func get_left_hand():
	return _left_hand
		
func get_right_hand():
	return _right_hand	

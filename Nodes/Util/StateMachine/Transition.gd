class_name Transition
extends Node

export var enabled : bool = true
export var transition_to : String
export var parameters : Dictionary

var state

func _prepare():
	pass


func _check(delta) -> Dictionary:
	return {}


func _clean_up():
	pass

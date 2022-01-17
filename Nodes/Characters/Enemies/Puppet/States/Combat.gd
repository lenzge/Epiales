extends SubStateMachineState


var _controlled_character : PuppetCharacter


func enter(_msg := {}):
	.enter(_msg)
	_controlled_character.is_focused = true


func exit():
	.exit()
	_controlled_character.is_focused = false


func set_controlled_character(value : PuppetCharacter):
	_controlled_character = value

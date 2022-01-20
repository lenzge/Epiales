extends Node

enum Devices {KEYBOARD, CONTROLER}

const UI_FOCUSED_COLOR : Color = Color(1.0, 0.0, 0.0, 1.0)
const UI_UNFOCUSED_COLOR : Color = Color(1.0, 1.0, 1.0, 1.0)

var current_device = Devices.KEYBOARD

func _unhandled_input(event):
	if event is InputEventKey or event is InputEventMouse:
		current_device = Devices.KEYBOARD
	elif event is InputEventJoypadButton or event is InputEventJoypadMotion:
		current_device = Devices.CONTROLER

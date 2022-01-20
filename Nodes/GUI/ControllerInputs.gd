extends Node2D


func _unhandled_input(event):
	if Globals.current_device == Globals.Devices.KEYBOARD:
		show_keyboard()
	elif Globals.current_device == Globals.Devices.CONTROLER:
		show_xbox_controler()


func show_keyboard():
	$XBox.visible = false
	$Keyboard.visible = true


func show_xbox_controler():
	$XBox.visible = true
	$Keyboard.visible = false

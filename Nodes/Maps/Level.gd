extends Node

export(String) var TITLE = ""
export(bool) var MAXIMIZED = true
var Player = preload("res://Nodes/Characters/Player.tscn").instance()

func _ready():
	OS.set_window_title(TITLE)
	OS.set_window_maximized(MAXIMIZED)
	self.add_child(Player)
	if $ParallaxBackground:
		print(true)
		var camera = Camera2D.new()
		camera.set_anchor_mode(Camera2D.ANCHOR_MODE_DRAG_CENTER)
		camera.set_offset(Player.position)
		camera.make_current()
		Player.add_child(camera)
		print(Player.get_children()[2].current)
	print(self.get_child(0).get_position_in_parent())

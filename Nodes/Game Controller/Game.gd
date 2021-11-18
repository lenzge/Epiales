class_name Game
extends Node

export var FULLSCREEN = false
export var MAXIMIZED = true
export (String) var GAME_TITLE

func _ready():
	OS.set_window_maximized(MAXIMIZED)
	OS.set_window_title(GAME_TITLE)
	

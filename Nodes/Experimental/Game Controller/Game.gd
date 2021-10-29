extends Node

export var FULLSCREEN = false
export var MAXIMIZED = true
export (String) var GAME_TITLE

const PLAYER = preload("res://Nodes/Characters/Player.tscn")
const LEVEL = preload("res://Nodes/Experimental/Maps/Level.tscn")
const START_SCREEN = preload("res://Nodes/Characters/Player.tscn")

var player_instance
var level_instance
var startscreen_instance
var pausescreen_instance
var gamestate = GAMESTATE.START

enum GAMESTATE {START, PLAYING, PAUSED, QUIT}

func _ready():
	OS.set_window_maximized(MAXIMIZED)

func _physics_process(delta):
	match gamestate:
		GAMESTATE.START:
			if !startscreen_instance:
				startscreen_instance = show_message("Press ENTER to start!")
				self.add_child(startscreen_instance)
				
			elif Input.is_action_just_pressed("ui_accept"):
				gamestate = GAMESTATE.PLAYING
				self.remove_child(self.get_child(0))
#				startscreen_instance.queue_free()
				
		GAMESTATE.PLAYING:
			if !level_instance:
				level_instance = LEVEL.instance()
				self.add_child(level_instance)
				
			elif !player_instance:
				player_instance = PLAYER.instance()
				self.add_child(player_instance)
				
			elif Input.is_action_just_pressed("ui_cancel"):
				gamestate = GAMESTATE.PAUSED
				get_tree().paused = true
				
		GAMESTATE.PAUSED:
			if !pausescreen_instance:
				pausescreen_instance = show_message("Paused")
				self.add_child(pausescreen_instance)
				
			elif Input.is_action_just_pressed("ui_cancel"):
				gamestate = GAMESTATE.PLAYING
				get_tree().paused = false
				self.remove_child(pausescreen_instance)
		GAMESTATE.QUIT:
			pass

func show_message(text: String) -> Panel:
	var message_box = Panel.new()
	var message = Label.new()
	message.text = text
	message_box.set_size(Vector2(50,300))
	message_box.add_child(message)
	message_box.set_position(OS.get_real_window_size() / 2)
	return message_box

extends Node

#const Menu = preload("res://Nodes/GUI/Startscreen.tscn")
enum GameState {START,PLAYING,PAUSE, GAMEOVER}
var game_state
var scene
var menu

func _ready():
	# set window parameters
	OS.set_window_maximized(true)
	OS.set_window_title("Epiales")	
	
	# set window to fullscreen
	# OS.set_window_fullscreen(true)
	
	game_state = GameState.START
	
	
func _physics_process(delta):
	match game_state:
		GameState.START:
			if !scene:
				scene = load("res://Nodes/GUI/Startscreen.tscn").instance()
				add_child(scene)
			if Input.is_action_just_pressed("ui_accept"):
				print("accepted")
				scene.queue_free()
				scene = null
				game_state = GameState.PLAYING
		GameState.PLAYING:
			if !scene:
				scene = load("res://Nodes/Maps/Level.tscn").instance()
				add_child(scene)
			if Input.is_action_just_pressed("ui_cancel"):
				menu = load("res://Nodes/GUI/Startscreen.tscn").instance()
				add_child(menu)
				set_physics_process(false)
				game_state = GameState.PAUSE
		#GameState.PAUSE:
			

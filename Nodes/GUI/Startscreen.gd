extends Node

enum GameState {START,PLAYING,PAUSE, GAMEOVER}
var game_state

const Level = preload("res://Nodes/Maps/Level.tscn")
const Player = preload("res://Nodes/Characters/player_lucy.tscn")

onready var start_label = $Panel/Label
onready var start_panel = $Panel

# Called when the node enters the scene tree for the first time.
func _ready():
	game_state = GameState.START
	show_message(true, "Press Space to Start")

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		game_state = GameState.PLAYING
		#Globals.play
		

func show_message(visible = false, text = ""):
	start_panel.visible = visible
	start_label.text = text

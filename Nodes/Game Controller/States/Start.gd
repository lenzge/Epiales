extends GameState

export(float, 0.01, 0.2) var modulation_change : float = 0.01
export(float) var wait_time : float = 2

var startscreen_scene = preload("res://Nodes/GUI/StartScreen.tscn")
var startscreen
var sprite : Node2D

var return_to_menu : bool = false
var timer : Timer


func _ready():
	._ready()
	timer = Timer.new()
	timer.set_autostart(false)
	timer.set_one_shot(true)
	timer.set_timer_process_mode(0)
	timer.connect("timeout", self, "_on_timeout")
	self.add_child(timer)


# Called by the state machine upon changing the active state
func enter(_msg := {}):
	startscreen = startscreen_scene.instance()
	startscreen.center()
#	sprite = startscreen.get_child(1)
#	sprite.set_position(OS.get_real_window_size() / 2)
	
	if game.get_node("HUD/fade_out").modulate.a > 0:
		timer.start(wait_time)
	else:
		show_startscreen()


func update(_delta):
	if return_to_menu:
		game.get_node("HUD/fade_out").modulate.a -= modulation_change
		
		if game.get_node("HUD/fade_out").modulate.a <= 0:
			game.get_node("HUD/fade_out").modulate.a = 0
			return_to_menu = false
			
			show_startscreen()


# Corresponds to the `_physics_process()` callback
func physics_update(_delta):
	
#	if Input.is_action_just_pressed("ui_accept"):
#		startscreen.animationPlayer.play("Close")
#		yield(startscreen, "close_finished")
#		state_machine.transition_to("Ingame")
	
#	if game.get_node("HUD/fade_out").modulate.a <= 0:
#		if Input.is_action_just_pressed("ui_accept"):
#			state_machine.transition_to("Ingame")
	pass

func start_game():
	startscreen.animationPlayer.play("Close")
	yield(startscreen, "close_finished")
	state_machine.transition_to("Ingame")


func show_startscreen():
	game.add_child(startscreen)
	startscreen.connect("start_game", self, "start_game")
	startscreen.menu_change_player.play("fade_in")


# Called by the state machine before changing the active state (clean up)
func exit():
	game.remove_child(startscreen)
	startscreen.queue_free()


func _on_timeout():
	return_to_menu = true

extends GameState

export(float, 0.01, 0.2) var modulation_change : float = 0.01
export(float) var wait_time : float = 2

var startscreen

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
	#placeholder startscreen
	startscreen = Panel.new()
	var message = Label.new()
	message.text = "Press ENTER to start!"
	startscreen.set_size(Vector2(300,50))
	startscreen.add_child(message)
	startscreen.set_position(OS.get_real_window_size() / 2)
	game.add_child(startscreen)
	
	if game.get_node("HUD/fade_out").modulate.a > 0:
		timer.start(wait_time)


func update(_delta):
	if return_to_menu:
		game.get_node("HUD/fade_out").modulate.a -= modulation_change
		
		if game.get_node("HUD/fade_out").modulate.a <= 0:
			game.get_node("HUD/fade_out").modulate.a = 0
			return_to_menu = false


# Corresponds to the `_physics_process()` callback
func physics_update(_delta):
	if game.get_node("HUD/fade_out").modulate.a <= 0:
		if Input.is_action_just_pressed("ui_accept"):
			state_machine.transition_to("Ingame")

# Called by the state machine before changing the active state (clean up)
func exit():
	game.remove_child(startscreen)
	startscreen.queue_free()


func _on_timeout():
	return_to_menu = true

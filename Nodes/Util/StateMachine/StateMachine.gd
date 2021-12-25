# Initializes states and delegates engine callbacks
class_name StateMachine
extends Node

# Emitted when transitioning to a new state.
signal transitioned(state_name)



export var auto_start : bool = true
# Initial state 
export var initial_state := NodePath()
onready var state = get_node(initial_state)
var last_state

# Assigns itself to an object
func _ready():
	yield(owner, "ready")
	for child in get_children():
		child.state_machine = self
	print("STATEMACHINE: Init. complete.")
	if auto_start:
		state.start_animation()
		state.enter()
	else:
		set_process(false)
		set_physics_process(false)
		set_process_input(false)
		set_process_unhandled_input(false)


# Delegates Input and all functionality to the current state
func _unhandled_input(event):
	state.handle_input(event)


func _process(delta):
	if state.processing_mode == 0:
		state.check_transitions(delta)
		for transition in state.transitions:
			if transition.enabled:
				var result : Dictionary = transition._check(delta)
				if result.has("transition_to"):
					transition_to(result.get("transition_to"), result.get("parameters", {}))
	state.update_animation(delta)
	state.update(delta)


func _physics_process(delta):
	if state.processing_mode == 1:
		state.check_transitions(delta)
		for transition in state.transitions:
			if transition.enabled:
				var result : Dictionary = transition._check(delta)
				if result.has("transition_to"):
					transition_to(result.get("transition_to"), result.get("parameters", {}))
	state.physics_update(delta)


func start(should_tick := true):
	set_process(should_tick)
	set_physics_process(should_tick)
	set_process_input(should_tick)
	set_process_unhandled_input(should_tick)
	state.start_animation()
	state.enter()
	for transition in state.transitions:
			if transition.enabled:
				transition._prepare()


func stop():
	set_process(false)
	set_physics_process(false)
	set_process_input(false)
	set_process_unhandled_input(false)
	for transition in state.transitions:
		if transition.enabled:
			transition._clean_up()
	state.exit()


# Calls the current state's exit() function, then changes the active state, and calls its enter function
func transition_to(target_state_name, msg: Dictionary = {}):
	# Safety check, if the state name is correct
	assert(has_node(target_state_name), "STATEMACHINE WARNING: State not found: " + target_state_name)
	
	# Dying can't be cancelled
	if not state.name == "Die":
		last_state = state
		for transition in state.transitions:
			if transition.enabled:
				transition._clean_up()
		state.exit()
		state = get_node(target_state_name)
		state.enter(msg)
		state.start_animation()
		for transition in state.transitions:
			if transition.enabled:
				transition._prepare()
		emit_signal("transitioned", state.name)



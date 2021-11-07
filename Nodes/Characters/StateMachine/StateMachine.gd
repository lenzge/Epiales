# Initializes states and delegates engine callbacks
class_name StateMachine
extends Node

# Emitted when transitioning to a new state.
signal transitioned(state_name)


# Initial state 
export var initial_state := NodePath()
onready var state: State = get_node(initial_state)

# Assigns itself to an object
func _ready():
	yield(owner, "ready")
	for child in get_children():
		child.state_machine = self
	state.enter()


# Delegates Input and all functionality to the current state
func _unhandled_input(event):
	state.handle_input(event)

func _process(delta):
	state.update(delta)

func _physics_process(delta):
	state.physics_update(delta)


# Calls the current state's exit() function, then changes the active state, and calls its enter function
func transition_to(target_state_name, msg: Dictionary = {}):
	# Safety check, if the state name is correct
	if not has_node(target_state_name):
		print("STATEMACHINE WARNING: State not found: " + target_state_name)
		return
	
	state.exit()
	state = get_node(target_state_name)
	state.enter(msg)
	emit_signal("transitioned", state.name)



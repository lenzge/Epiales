# Initializes states and delegates engine callbacks
class_name SubStateMachine
extends State

# Emitted when transitioning to a new state.
signal transitioned(state_name)

var last_state
# Initial state 
export var initial_state := NodePath()
export var should_start_at_initial_state : bool
onready var state: State = get_node(initial_state)
#onready var animationPlayer = $"../AnimationPlayer"

# Assigns itself to an object
func _ready():
	yield(owner, "ready")
	for child in get_children():
		child.state_machine = self
	print("STATEMACHINE: Init. complete.")


func enter(_msg = {}):
	if should_start_at_initial_state:
		state = get_node(initial_state)
	state.enter(_msg)
	state.start_animation()


# Delegates Input and all functionality to the current state
func handle_input(event):
	state.handle_input(event)


func update(delta):
	if state.processing_mode == 0:
		state.check_transitions(delta)
	update_animation(delta)
	state.update(delta)


func physics_update(delta):
	if state.processing_mode == 0:
		state.check_transitions(delta)
	state.physics_update(delta)


func exit():
	state.exit()


# Calls the current state's exit() function, then changes the active state, and calls its enter function
func transition_to(target_state_name, msg: Dictionary = {}):
	# Safety check, if the state name is correct
	assert(has_node(target_state_name), "STATEMACHINE WARNING: State not found: " + target_state_name)
	
	last_state = state
	state.exit()
	state = get_node(target_state_name)
	state.enter(msg)
	state.start_animation()
	emit_signal("transitioned", state.name)

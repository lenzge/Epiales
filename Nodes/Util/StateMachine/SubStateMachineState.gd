# Initializes states and delegates engine callbacks
class_name SubStateMachineState
extends State

export var sub_state_machine_path : NodePath
export var should_start_at_initial_state : bool = true

onready var sub_state_machine = get_node(sub_state_machine_path)

func enter(_msg = {}):
	if should_start_at_initial_state:
		sub_state_machine.state = sub_state_machine.get_node(sub_state_machine.initial_state)
	sub_state_machine.start(false)


# Delegates Input and all functionality to the current state
func handle_input(event):
	sub_state_machine._unhandled_input(event)


func update(delta):
	sub_state_machine._process(delta)


func physics_update(delta):
	sub_state_machine._physics_process(delta)


func exit():
	sub_state_machine.stop()

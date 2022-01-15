extends State

export var next_state : String
export var parameters : Dictionary
export(int, 1, 100) var min_look_arounds : int = 2
export(int, 1, 100) var max_look_arounds : int = 3
export var min_look_time : float = 1.0
export var max_look_time : float = 1.0

onready var _timer : Timer = Timer.new()
onready var _rng : RandomNumberGenerator = RandomNumberGenerator.new()

var _controlled_character : Character

var look_count : int

func _ready():
	add_child(_timer)
	_timer.connect("timeout", self, "_on_timeout")


func enter(_msg := {}):
	_rng.randomize()
	look_count = _rng.randi_range(min_look_arounds, max_look_arounds)
	look_count -= 1
	_controlled_character.flip()
	_timer.start(_rng.randf_range(min_look_time, max_look_time))


func _on_timeout():
	if look_count <= 0:
		state_machine.transition_to(next_state, parameters)
	else:
		_controlled_character.flip()
		_rng.randomize()
		_timer.start(_rng.randf_range(min_look_time, max_look_time))
	look_count -= 1


func set_controlled_character(value : Character):
	_controlled_character = value


func exit():
	_timer.stop()

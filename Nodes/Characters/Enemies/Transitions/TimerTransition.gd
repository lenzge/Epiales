extends Transition

export var time : float
export var is_random : bool
export var time_min : float
export var time_max : float

onready var _timer : Timer = Timer.new()
onready var _rng : RandomNumberGenerator = RandomNumberGenerator.new()

var should_transition

func _ready():
	add_child(_timer)
	_timer.connect("timeout", self, "_on_timeout")


func _prepare(_msg := {}):
	should_transition = false
	_rng.randomize()
	if is_random:
		_timer.start(_rng.randf_range(time_min, time_max))
	else:
		_timer.start(time)


func _check(delta) -> Dictionary:
	if should_transition:
		return {"transition_to": transition_to,"parameters": parameters}
	else:
		return {}


func _cleanup():
	_timer.stop()


func _on_timeout():
	should_transition = true

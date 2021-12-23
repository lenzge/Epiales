extends State

export var time_min : float
export var time_max : float

onready var _timer : Timer = Timer.new()
onready var _rng : RandomNumberGenerator = RandomNumberGenerator.new()

func _ready():
	self.add_child(_timer)
	_timer.connect("timeout", self, "_on_timeout")


func enter(_msg := {}):
	_rng.randomize()
	_timer.start(_rng.randf_range(time_min, time_max))


func exit():
	_timer.stop()


func _on_timeout():
	state_machine.transition_to("LookAround")

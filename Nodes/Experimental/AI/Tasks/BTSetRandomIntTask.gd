extends BTLeaf

export var bb_entry : String
export var min_value : float = 0
export var max_value : float = 1

var rng : RandomNumberGenerator

func _ready():
	._ready()
	rng = RandomNumberGenerator.new()

func _tick(agent : Node, blackboard : Blackboard):
	rng.randomize()
	blackboard.set_data(bb_entry, rng.randf_range(min_value, max_value))

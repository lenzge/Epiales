extends BTLeaf

export var bb_entry : String
export var min_value : int = 0
export var max_value : int = 1

var rng : RandomNumberGenerator

func _ready():
	._ready()
	rng = RandomNumberGenerator.new()

func _tick(agent : Node, blackboard : Blackboard):
	rng.randomize()
	blackboard.set_data(bb_entry, rng.randi_range(min_value, max_value))

extends AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	animation_set_next("Run_Start", "Run_Loop")
	animation_set_next("Walk_Start", "Walk_Loop")
	animation_set_next("Run_End", "Idle")
	animation_set_next("Walk_End", "Idle")



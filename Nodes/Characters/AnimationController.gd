extends AnimationPlayer

func _ready():
	animation_set_next("Run_Turn","Idle")
	self.connect("animation_finished", self, "_on_animation_finished")
	

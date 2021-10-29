extends ParallaxLayer

export(bool) var MOVEMENT = false
export(float) var CLOUD_SPEED = -15

func _process(delta):
	if(MOVEMENT):
		self.motion_offset.x += CLOUD_SPEED * delta

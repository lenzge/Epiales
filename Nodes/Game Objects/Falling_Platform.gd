extends StaticBody2D

const MS_PER_SECOND = 1_000

var velocity = Vector2(0, 0)
var shaking = false
var falling = false
var disappear = false

export var time_to_fall = 100
export var time_to_disappear = 500
export var gravity = 3000
export(float, 0.1, 10.0) var disappear_speed = 0.1
export var shakiness = 0

func _ready():
	pass

func _process(delta):
	if shaking and shakiness > 0:
		var positionX = shakiness * sin(OS.get_ticks_msec())
		var positionY = shakiness * sin(OS.get_ticks_usec())
		$Sprite.position = Vector2(0 + positionX, 0 + positionY)
	else:
		if falling:
			self.position.y += gravity * delta
		if disappear:
			$Sprite.modulate.a -= disappear_speed
			if $Sprite.modulate.a <= 0.0:
				self.queue_free()


#func reset():
#	pass


func _on_Player_Detector_body_entered(body):
	if body is Player:
		$Timer_StartFalling.start(time_to_fall / MS_PER_SECOND)
		shaking = true


func _on_Timer_StartFalling_timeout():
	$Timer_StartFalling.stop()
	falling = true
	shaking = false
	$Sprite.position = Vector2(0, 0)
	$Timer_Disapear.start(time_to_disappear / MS_PER_SECOND)


func _on_Timer_Disapear_timeout():
	$Timer_Disapear.stop()
	disappear = true

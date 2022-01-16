extends Control


onready var animationPlayer = $AnimationPlayer
var _rng = RandomNumberGenerator.new()

signal close_finished

func _ready():
	animationPlayer.play("Idle")

func _on_close_timeout():
	emit_signal("close_finished")

func update():
	emit_signal("close_finished")


func _on_AnimationPlayer_animation_finished(anim_name):
	var _animation = _rng.randi_range(1,3)
	if _animation == 1:
		animationPlayer.play("Idle")
	elif _animation == 2:
		animationPlayer.play("Blink")
	elif _animation == 3:
		animationPlayer.play("Look_Around")

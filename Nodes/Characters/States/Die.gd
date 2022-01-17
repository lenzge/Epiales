extends PlayerState

func _ready():
	._ready()
	yield(owner, "ready")


func enter(_msg := {}):
	animationPlayer.play("Idle")
	animationPlayer.set_speed_scale(1)

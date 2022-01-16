extends Control


onready var animationPlayer = $AnimationPlayer

signal close_finished

func _ready():
	animationPlayer.play("Idle")

func _on_close_timeout():
	emit_signal("close_finished")

func update():
	emit_signal("close_finished")



extends "res://Nodes/Game Objects/Deadzone.gd"

export (float) var deadly_time = 2

onready var timer = $Timer
onready var sprite = $Sprite
onready var colider = $CollisionShape2D

func _ready():
	timer.start(deadly_time)

func _on_Timer_timeout():
	sprite.visible = !sprite.visible
	colider.set_deferred("disabled", !colider.disabled)

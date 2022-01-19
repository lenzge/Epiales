extends Area2D

onready var animationPlayer : AnimationPlayer = $AnimationPlayer
onready var collisionShape : CollisionShape2D = $CollisionShape2D

func _ready():
	animationPlayer.animation_set_next("Spawn", "Idle")
	collisionShape.disabled = true

func spawn():
	animationPlayer.play("Spawn")
	collisionShape.disabled = false

func despawn():
	animationPlayer.play("Depawn")
	collisionShape.disabled = true




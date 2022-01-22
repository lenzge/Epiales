extends Area2D

onready var animationPlayer : AnimationPlayer = $AnimationPlayer
onready var collisionShape : CollisionShape2D = $CollisionShape2D
onready var staticbody : StaticBody2D = $Border
onready var sound_machine : SoundMachine = $SoundMachine

func _ready():
	animationPlayer.animation_set_next("Spawn", "Idle")

func spawn():
	animationPlayer.play("Spawn")
	collisionShape.disabled = false

func despawn():
	animationPlayer.play("Despawn")
	collisionShape.disabled = true

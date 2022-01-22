extends Node2D


var animationPlayer : AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	animationPlayer  = $AnimationPlayer
	animationPlayer.animation_set_next("Fill", "Idle_Filled")
	animationPlayer.animation_set_next("Empty", "Idle_Empty")
	animationPlayer.play("Idle_Empty")

func fill():
	animationPlayer.play("Fill")
	
func empty():
	animationPlayer.play("Empty")

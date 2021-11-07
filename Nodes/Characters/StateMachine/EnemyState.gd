class_name EnemyState
extends State

var enemy : Puppet
onready var animationPlayer = $"../../AnimationPlayer"

# Owner of the statemachine is a enemy
func _ready():
	yield(owner, "ready")
	enemy = owner as Puppet
	assert(enemy != null)

func enter(_msg := {}):
	animationPlayer.play(self.name)


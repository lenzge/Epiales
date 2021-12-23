extends PlayerState

onready var player_collision = get_node("../../CollisionShape2D")
export (int) var COLLISION_LAYER_BIT = 3
onready var collision_bit

func enter(msg :={}):
	#.enter(msg)
	pass

func update(delta):
	if player.velocity.x > 100:
		animationPlayer.play("Slide")
	else:
		animationPlayer.play("Crouch")
	
	if not player.is_on_floor():
		state_machine.transition_to("Fall")
	elif Input.is_action_just_pressed("attack"):
		state_machine.transition_to("Attack_Down_Ground_Windup")
	elif !Input.is_action_pressed("move_down"):
		state_machine.transition_to("Idle")
	elif Input.is_action_just_pressed("jump"):
		state_machine.transition_to("Jump")
	elif Input.is_action_just_pressed("dash"):
		state_machine.transition_to("Dash")
	elif Input.is_action_just_pressed("block"):
		state_machine.transition_to("Block_Windup")


func physics_update(delta):
	player.crouch_move(delta)

	

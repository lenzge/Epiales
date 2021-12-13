extends PlayerState

func enter(msg :={}):
	.enter(msg)
	player._enter_crouch()


func update(delta):
	if not player.is_on_floor():
		player._exit_crouch()
		state_machine.transition_to("Fall")
	elif Input.is_action_just_pressed("attack"):
		state_machine.transition_to("Attack_Down_Ground_Windup")
	elif !Input.is_action_pressed("move_down"):
		player._exit_crouch()
		state_machine.transition_to("Idle")
	elif Input.is_action_just_pressed("jump"):
		player._exit_crouch()
		state_machine.transition_to("Jump")
	elif Input.is_action_just_pressed("dash"):
		player._exit_crouch()
		state_machine.transition_to("Dash")
	elif Input.is_action_just_pressed("block"):
		state_machine.transition_to("Crouch_Block_Windup")


func physics_update(delta):
	player.crouch_move(delta)

# maybe need later
func _set_hitbox(to_crouch):
	if to_crouch == 1:
		player.hitbox.get_child(0).shape.height = player.collision_shape.shape.height/2
		player.hitbox.get_child(0).position.y = player.hitbox.get_child(0).position.y + player.collision_shape.shape.height/4
		player.collision_shape.shape.height = player.collision_shape.shape.height/2
		player.collision_shape.position.y = player.collision_shape.position.y + player.collision_shape.shape.height/2
	else:
		player.collision_shape.position.y = player.collision_shape.position.y - player.collision_shape.shape.height/2
		player.collision_shape.shape.height = player.collision_shape.shape.height * 2
		player.hitbox.get_child(0).shape.height = player.collision_shape.shape.height
		player.hitbox.get_child(0).position.y = player.hitbox.get_child(0).position.y - player.collision_shape.shape.height/4
	
	
	

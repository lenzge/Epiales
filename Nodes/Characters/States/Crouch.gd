extends PlayerState

var collision_pos_y_change : float
var collision_shape_original_height : float = 0.0

func enter(msg :={}):
	.enter(msg)
	
	if collision_shape_original_height == 0.0:
		collision_shape_original_height = player.get_node("CollisionShape2D").shape.height
	
	var collision_shape = player.get_node("CollisionShape2D")
	if collision_shape_original_height == collision_shape.shape.height:
		collision_shape.shape.height /= 2
		
		collision_pos_y_change = collision_shape.shape.height / 2
		
		collision_shape.position.y += collision_pos_y_change
		player.get_node("Hitbox/Hitbox").position.y += collision_pos_y_change


func exit_crouch():
	var collision_shape = player.get_node("CollisionShape2D")
	collision_shape.position.y -= collision_pos_y_change
	player.get_node("Hitbox/Hitbox").position.y -= collision_pos_y_change
	collision_shape.shape.height *= 2


func update(delta):
	if Input.is_action_just_pressed("attack"):
		state_machine.transition_to("Attack_Down_Ground_Windup")
	elif !Input.is_action_pressed("move_down"):
		state_machine.transition_to("Idle")
		exit_crouch()
	elif Input.is_action_just_pressed("jump"):
		state_machine.transition_to("Jump")
		exit_crouch()
	elif Input.is_action_just_pressed("dash"):
		state_machine.transition_to("Dash")
		exit_crouch()


func physics_update(delta):
	player.crouch_move(delta)

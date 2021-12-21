extends PlayerState

onready var player_collision = get_node("../../CollisionShape2D")
export (int) var COLLISION_LAYER_BIT = 3
onready var collision_bit

func enter(msg :={}):
	.enter(msg)
	player._enter_crouch()

func update(delta):
	if not player.is_on_floor():
		pass
#		player._exit_crouch()
#		state_machine.transition_to("Fall")
	elif Input.is_action_just_pressed("attack"):
		state_machine.transition_to("Attack_Down_Ground_Windup")
	elif !Input.is_action_pressed("move_down"):
		player._exit_crouch()
		state_machine.transition_to("Idle")
	elif Input.is_action_just_pressed("jump"):
		crouch_jump()
		player.is_on_floor()
	elif Input.is_action_just_pressed("dash"):
		player._exit_crouch()
		state_machine.transition_to("Dash")
	elif Input.is_action_just_pressed("block"):
		state_machine.transition_to("Crouch_Block_Windup")


func physics_update(delta):
	player.crouch_move(delta)

func crouch_jump():
#	player.position.y+=10
	player.set_collision_mask_bit(2,false)
	player._exit_crouch()
	state_machine.transition_to("Fall")

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



func _on_GroundDetection_area_exited(area):
	pass # Replace with function body.


func _on_GroundDetection_body_shape_exited(body_id, body, body_shape, local_shape):
	player.set_collision_mask_bit(2,true)
	print("body name: ",body.name)
	print("body id: ",body_id)
	print("body shape: ",body_shape)
	print("local shape: ",local_shape)

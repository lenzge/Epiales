extends PlayerState

onready var player_collision = get_node("../../CollisionShape2D")
export (int) var COLLISION_LAYER_BIT = 3
onready var collision_bit
var can_crouch_jump = true

func enter(msg :={}):
	if abs(player.velocity.x) > 100:
		animationPlayer.play("Slide")
		player.sound_machine.play_sound("Slide", false)
	elif state_machine.last_state.name == "Attack_Down_Recovery":
		animationPlayer.play("Crouch")
	else:
		animationPlayer.play("Crouch_Start")
	
	# Play sound only when player gets into crouch
	if state_machine.last_state.name != "Attack_Down_Recovery":
		player.sound_machine.play_sound("Crouch Down", false)


func exit():
	.exit()
	# Play sound only when player leaves crouch
	if state_machine.new_state != "Attack_Down_Windup":
		player.sound_machine.play_sound("Crouch Up", false)


func physics_update(delta):
	
	if abs(player.velocity.x) > 100:
		animationPlayer.play("Slide")
	elif animationPlayer.current_animation == "Slide":
		animationPlayer.play("Slide_Crouch")
	
	player.decelerate_move_ground(delta, true)
	
	if not player.is_on_floor():
		state_machine.transition_to("Fall")
	elif Input.is_action_just_pressed("attack"):
		state_machine.transition_to("Attack_Down_Windup")
	elif !Input.is_action_pressed("move_down") and not player.last_movement_buttons.empty():
		state_machine.transition_to("Run")
	elif !Input.is_action_pressed("move_down"):
		state_machine.transition_to("Idle")
	elif Input.is_action_just_pressed("jump"):
		crouch_jump();
	elif Input.is_action_just_pressed("dash") and player.can_dash:
		state_machine.transition_to("Dash")
	elif Input.is_action_just_pressed("block"):
		state_machine.transition_to("Block_Windup")


func crouch_jump():
	if can_crouch_jump:
		player.set_collision_mask_bit(2,false)
		state_machine.transition_to("Fall")

func _on_GroundDetection_body_shape_exited(body_id, body, body_shape, local_shape):
	if body is TileMap and state_machine.last_state.name == "Crouch" and state_machine.new_state == "Fall":
		player.set_collision_mask_bit(2,true)

# Checks if Player is on Platform or on solid ground. Only true if Player is on Platform
func _on_Area2D_body_shape_entered(body_id, body, body_shape, local_shape):
	if body is TileMap:
		can_crouch_jump = false

# Checks if Player is on Platform or on solid ground. Set true when Player leaves solid ground.
func _on_Area2D_body_shape_exited(body_id, body, body_shape, local_shape):
	if body is TileMap:
		can_crouch_jump = true

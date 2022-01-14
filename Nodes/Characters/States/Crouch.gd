extends PlayerState

onready var player_collision = get_node("../../CollisionShape2D")
export (int) var COLLISION_LAYER_BIT = 3
onready var collision_bit
var can_crouch_jump = true

func enter(msg :={}):
	#.enter(msg)
	pass

func update(delta):
	print("[DEBUG in Crouch] can jump: ", can_crouch_jump)
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
		crouch_jump();
	elif Input.is_action_just_pressed("dash"):
		state_machine.transition_to("Dash")
	elif Input.is_action_just_pressed("block"):
		state_machine.transition_to("Block_Windup")


func physics_update(delta):
	player.crouch_move(delta)

func crouch_jump():
	if can_crouch_jump:
		player.set_collision_mask_bit(2,false)
		state_machine.transition_to("Fall")

func _on_GroundDetection_body_shape_exited(body_id, body, body_shape, local_shape):
	if body is TileMap and state_machine.last_state.name == "Crouch" and state_machine.new_state == "Fall":
		print(OS.get_time(),"  :"," body_id: ",body_id, " body: ",body, " body_shape: ", " local_shape: ",local_shape)
		print(OS.get_time(),"  :"," tilesetIDs: ",body.get_tileset().tile_get_name(0))
		player.set_collision_mask_bit(2,true)

# Checks if Player is on Platform or on solid ground. Only true if Player is on Platform
func _on_Area2D_body_shape_entered(body_id, body, body_shape, local_shape):
	if body is TileMap:
		can_crouch_jump = false

# Checks if Player is on Platform or on solid ground. Set true when Player leaves solid ground.
func _on_Area2D_body_shape_exited(body_id, body, body_shape, local_shape):
	if body is TileMap:
		can_crouch_jump = true

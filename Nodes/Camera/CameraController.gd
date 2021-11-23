extends Camera2D


enum Mode{
	STATIC, # Do not move from specified position
	FOLLOW, # Follow parent object
#	TRANSITION, # Transition smoothly between modes
	CUTSCENE, # Control Camera through commands
}

# Camera variables
export var current_mode = Mode.FOLLOW
export var camera_speed = 500.0
export var reverse_drag = 0.75
export var destination = Vector2(0, 0)
export var bottom_margin = 0
export var side_margin = 0
export var player_path : NodePath

# Raycast Variables to define camera collision limits
export var raycast_down_cast_to = Vector2.DOWN
export var raycast_left_cast_to = Vector2.LEFT
export var raycast_right_cast_to = Vector2.RIGHT

onready var raycast_down = get_node("RayCast2D_Down")
onready var raycast_left = get_node("RayCast2D_Left")
onready var raycast_right = get_node("RayCast2D_Right")
onready var player = get_node(player_path)

# Called when the node enters the scene tree for the first time.
func _ready():
	
	update_raycasts()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	update_raycasts()
	if Input.is_action_pressed("debug"):
		if current_mode == Mode.STATIC:
			current_mode = Mode.FOLLOW
		else:
			current_mode = Mode.STATIC

	match current_mode:
		Mode.FOLLOW:
			var reverse_drag_vector = Vector2(0, 0) if player.velocity && player.velocity.x == 0 else Vector2(player.velocity.x, 0.0) * reverse_drag 
			destination = player.global_position + reverse_drag_vector
		Mode.CUTSCENE:
			pass
	
	#if raycast_down.is_colliding():
		#print(raycast_down, raycast_down.get_collision_point(), raycast_down.get_cast_to(), raycast_down.get_collider().name, " I am colliding down!")
		#destination.y = min(destination.y, raycast_down.get_collision_point().y - raycast_down.get_cast_to().y) #min(destination.y, raycast_down.get_collision_point().y - bottom_margin)
	
	if raycast_left.is_colliding():
		if raycast_right.is_colliding():
			#print("We are colliding!", raycast_left.get_collision_point(), raycast_right.get_collision_point(), raycast_right.get_collision_point().x + raycast_left.get_collision_point().x / 2)
			destination.x = (raycast_right.get_collision_point().x + raycast_left.get_collision_point().x) / 2
		else:	
			#print(raycast_left, raycast_left.get_collision_point(), raycast_left.get_cast_to(), raycast_left.get_collider().name, " I am colliding left!")
			destination.x = max(destination.x, raycast_left.get_collision_point().x - raycast_left.get_cast_to().x)#max(destination.x, raycast_left.get_collision_point().x + side_margin)

	elif raycast_right.is_colliding():
		#print(raycast_right, raycast_right.get_collision_point(), raycast_right.get_cast_to(), raycast_right.get_collider().name, " I am colliding right!")
		destination.x = min(destination.x, raycast_right.get_collision_point().x - raycast_right.get_cast_to().x)#min(destination.x, raycast_right.get_collision_point().x - side_margin)
	
	# Move the camera towards the destination
	if destination.round() != global_position.round():
		global_position = global_position.move_toward(destination, camera_speed * delta)


func set_destination(var new_destination):
	destination = new_destination


func set_mode(var new_mode):
	current_mode = new_mode
	
func update_raycasts():
	var raycast_factor_h = get_viewport().size.x / 10
	var raycast_factor_v = get_viewport().size.y / 10
	raycast_down.set_cast_to(raycast_down_cast_to * raycast_factor_v)
	raycast_left.set_cast_to(raycast_left_cast_to * raycast_factor_h)
	raycast_right.set_cast_to(raycast_right_cast_to * raycast_factor_h)

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

onready var parent = get_parent()


# Raycast Variables to define camera collision limits
export var raycast_down_cast_to = Vector2(0, 100)
export var raycast_left_cast_to = Vector2(-100, 0)
export var raycast_right_cast_to = Vector2(100, 0)

onready var raycast_down = get_node("RayCast2D_Down")
onready var raycast_left = get_node("RayCast2D_Left")
onready var raycast_right = get_node("RayCast2D_Right")


# Called when the node enters the scene tree for the first time.
func _ready():
	set_as_toplevel(true)
	position = parent.position

	raycast_down.set_cast_to(raycast_down_cast_to)
	raycast_left.set_cast_to(raycast_left_cast_to)
	raycast_right.set_cast_to(raycast_right_cast_to)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("debug"):
		if current_mode == Mode.STATIC:
			current_mode = Mode.FOLLOW
		else:
			current_mode = Mode.STATIC

	match current_mode:
		Mode.STATIC:
			destination = position
		Mode.FOLLOW:
			var reverse_drag_vector = Vector2(0, 0) if parent.velocity && parent.velocity.x == 0 else Vector2(parent.velocity.x, 0.0) * reverse_drag 
			destination = parent.position + reverse_drag_vector
			#position = position.move_toward(parent.position + reverse_drag_vector, camera_speed * delta)
		Mode.CUTSCENE:
			pass
	if destination.round() != position.round():
		position = position.move_toward(destination, camera_speed * delta)	
		
	
	raycast_down.position = position
	raycast_left.position = position
	raycast_right.position = position
	
	if raycast_down.get_collider():
		print(raycast_down, raycast_down.get_collision_point(), raycast_down.get_cast_to(), raycast_down.get_collider(), " I am colliding!")
	
	if raycast_left.get_collider():
		print(raycast_left, raycast_left.get_collision_point(), raycast_left.get_cast_to(), raycast_left.get_collider(), " I am colliding!")

	if raycast_right.get_collider():
		print(raycast_right, raycast_right.get_collision_point(), raycast_right.get_cast_to(), raycast_right.get_collider(), " I am colliding!")

			
			
func set_destination(var new_destination):
	destination = new_destination
	
func set_mode(var new_mode):
	current_mode = new_mode

extends Camera2D


enum Mode{
	STATIC, # Do not move from specified position
	FOLLOW, # Follow parent object
#	TRANSITION, # Transition smoothly between modes
	CUTSCENE, # Control Camera through commands
}

export var current_mode = Mode.FOLLOW
export var camera_speed = 500.0
export var reverse_drag = 0.75
export var destination = Vector2(0, 0)

onready var parent = get_parent()


# Called when the node enters the scene tree for the first time.
func _ready():
	set_as_toplevel(true)
	position = parent.position


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
		
func set_destination(var new_destination):
	destination = new_destination
	
func set_mode(var new_mode):
	current_mode = new_mode

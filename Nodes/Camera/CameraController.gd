extends Camera2D


enum Mode{
	STATIC, # Do not move from specified position
	FOLLOW, # Follow parent object
	TRANSITION, # Transition smoothly between modes
	CUTSCENE, # Control Camera through commands
}

var current_mode = Mode.FOLLOW
var camera_speed = 500.0
var reverse_drag = 0.75

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
		Mode.FOLLOW:
			var reverse_drag_vector = Vector2(0, 0) if parent.velocity && parent.velocity.x == 0 else Vector2(parent.velocity.x, 0.0) * reverse_drag 
			self.position = self.position.move_toward(parent.position + reverse_drag_vector, camera_speed * delta)
		Mode.STATIC:
			pass
			

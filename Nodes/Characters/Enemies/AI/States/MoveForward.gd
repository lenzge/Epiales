extends State

export var floor_detection_ray_path : NodePath
export var wall_detection_ray_path : NodePath
export (float, 0, 1) var move_speed : float

onready var _floor_detection_ray : RayCast2D = get_node(floor_detection_ray_path)
onready var _wall_detection_ray : RayCast2D = get_node(wall_detection_ray_path)
var _controlled_character : Character

func physics_update(delta):
	if !_floor_detection_ray.is_colliding() || _wall_detection_ray.is_colliding():
		_controlled_character.flip()
	
	var direction_x = 1 if _controlled_character.is_facing_right else -1
	_controlled_character.move(Vector2(direction_x * move_speed, 0))

func set_controlled_character(controlled_character : Character):
	_controlled_character = controlled_character

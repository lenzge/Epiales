extends SubStateMachineState

export var floor_detection_ray_path : NodePath
export var wall_detection_ray_path : NodePath

var controlled_character : PuppetCharacter

func _ready():
	_set_up()


func _set_up():
	$StateMachine/MoveForward.floor_detection_ray = get_node(floor_detection_ray_path)
	$StateMachine/MoveForward.wall_detection_ray = get_node(wall_detection_ray_path)

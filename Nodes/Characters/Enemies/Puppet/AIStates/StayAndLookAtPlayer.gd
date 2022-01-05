extends State

export var flip_delay : float
export var attack_range_close : float
#export var attack_range_far : float
#export var min_towards_velocity : float
export var max_y_difference : float

var controlled_character : Character
var ai_controller

var focused_player : Player
var flip_delay_timer : Timer

func _ready():
	flip_delay_timer = Timer.new()
	flip_delay_timer.process_mode = 0
	flip_delay_timer.one_shot = true
	add_child(flip_delay_timer)


func enter(_msg := {}):
	focused_player = ai_controller.get_focused_player()


func physics_update(delta):
	var is_player_in_back = (focused_player.global_position - controlled_character.global_position).x < 0.0 == controlled_character.is_facing_right
	
	if is_player_in_back:
		if flip_delay_timer.is_stopped():
			flip_delay_timer.start(flip_delay)
	else:
		flip_delay_timer.stop()


func check_transitions(delta):
	var enemy_to_player = (focused_player.global_position - controlled_character.global_position)
	var is_player_in_back = enemy_to_player.x < 0.0 == controlled_character.is_facing_right
	
	if !is_player_in_back and enemy_to_player.length() < attack_range_close and abs(enemy_to_player.y) < max_y_difference:
		pass


func exit():
	flip_delay_timer.stop()


func set_controlled_character(value : Character):
	controlled_character = value
	flip_delay_timer.connect("timeout", controlled_character, "flip")


func set_ai_controller(value : Node):
	ai_controller = value

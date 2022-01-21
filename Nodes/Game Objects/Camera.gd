extends Camera2D

enum MoveState {LEFT, RIGHT, UP, DOWN, IDLE}

onready var player : Player = get_parent()
onready var ray_left : RayCast2D = $Left
onready var ray_right : RayCast2D = $Right
onready var ray_up : RayCast2D = $Up
onready var ray_down : RayCast2D = $Down

export(float) var max_offset : float = 200.0
export(float) var speed : float = 3.0
export(float, 0.01, 0.2) var drag: float = 0.03

var current_state_x = MoveState.IDLE
var current_state_y = MoveState.IDLE
var prev_state_x = MoveState.IDLE
var prev_state_y = MoveState.IDLE

var to_point : Vector2 = Vector2.ZERO
var raw_value : Vector2 = Vector2.ZERO
var drag_x : float = 0.0
var drag_y : float = 0.0


func _ready():
	pass


func _process(delta):
	
	to_point.x = clamp((threshold(player.velocity.x, player.speed / 2) / player.speed) * max_offset, -max_offset, max_offset)
	to_point.y = clamp((threshold(player.velocity.y, player.speed / 4) / player.speed) * max_offset, -max_offset, max_offset)
	
	print(to_point)
	
	# x
	if raw_value.x < to_point.x:
		current_state_x = MoveState.RIGHT
		
		if current_state_x != prev_state_x:
			drag_x = 0.0
			prev_state_x = current_state_x
		elif drag_x < 1.0:
			drag_x += drag
		else: drag_x = 1.0
		
		raw_value.x += speed * drag_x
		
		if raw_value.x >= to_point.x:
			raw_value.x = to_point.x
			current_state_x = MoveState.IDLE
			
	elif raw_value.x > to_point.x:
		current_state_x = MoveState.LEFT
		
		if current_state_x != prev_state_x:
			drag_x = 0.0
			prev_state_x = current_state_x
		elif drag_x < 1.0:
			drag_x += drag
		else: drag_x = 1.0
		
		raw_value.x -= speed * drag_x
		
		if raw_value.x <= to_point.x:
			raw_value.x = to_point.x
			current_state_x = MoveState.IDLE
	
	# y
	if raw_value.y < to_point.y:
		current_state_y = MoveState.DOWN
		
		if current_state_y != prev_state_y:
			drag_y = 0.0
			prev_state_y = current_state_y
		elif drag_y < 1.0:
			drag_y += drag
		else: drag_y = 1.0
		
		raw_value.y += speed * drag_y
		
		if raw_value.y >= to_point.y:
			raw_value.y = to_point.y
			current_state_y = MoveState.IDLE

	elif raw_value.y > to_point.y:
		current_state_y = MoveState.UP
		
		if current_state_y != prev_state_y:
			drag_y = 0.0
			prev_state_y = current_state_y
		elif drag_y < 1.0:
			drag_y += drag
		else: drag_y = 1.0
		
		raw_value.y -= speed * drag_y
		
		if raw_value.y <= to_point.y:
			raw_value.y = to_point.y
			current_state_y = MoveState.IDLE
	
	self.offset.x = ease_func(abs(raw_value.x / max_offset)) * max_offset * get_sign(raw_value.x)
	self.offset.y = ease_func(abs(raw_value.y / max_offset)) * max_offset * get_sign(raw_value.y)


func threshold(value: float, threshold: float):
	if abs(value) >= threshold:
		return value
	else:
		return 0


func get_sign(value: float) -> int:
	var ret_val = 1
	if value < 0:
		ret_val = -1
	return ret_val


## ease_in_out cubic
func ease_func(value: float) -> float:
	var ret_val: float = 0.0
	if value < 0.5:
		ret_val = 4 * value * value * value
	else:
		ret_val = 1 - pow(-2 * value + 2, 3) / 2
	return ret_val


func check_collision_x():
	pass


func check_collision_y():
	pass

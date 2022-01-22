extends Camera2D

enum MoveState {LEFT, RIGHT, UP, DOWN, IDLE}
enum EaseModes {IN, OUT, IN_OUT}

onready var player : Player = get_parent()

export(float) var max_offset : float = 200.0
export(float) var speed : float = 3.0
export(float, 0.01, 0.2) var drag: float = 0.03
export(EaseModes) var ease_mode = EaseModes.IN

export(float) var animation_speed : float = 50.0

var current_state_x = MoveState.IDLE
var current_state_y = MoveState.IDLE
var prev_state_x = MoveState.IDLE
var prev_state_y = MoveState.IDLE

var to_point : Vector2 = Vector2.ZERO
var raw_value : Vector2 = Vector2.ZERO
var drag_x : float = 0.0
var drag_y : float = 0.0

var reset_bool : bool = false
var animate_to_bool : bool = false
var animate_to_global_position : Vector2 = Vector2.ZERO
var animation_raw_value : Vector2 = Vector2.ZERO
var animation_save_global_camera_position : Vector2
var animation_x_rate : float = 0.0
var animation_y_rate : float = 0.0


func _ready():
	pass


func _process(delta):
	
	if !animate_to_bool:
		to_point.x = clamp((threshold(player.velocity.x, player.speed / 2) / player.speed) * max_offset, -max_offset, max_offset)
		to_point.y = clamp((threshold(player.velocity.y, player.speed / 4) / player.speed) * max_offset, -max_offset, max_offset)
		
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
		
		match(ease_mode):
			EaseModes.IN:
				self.position.x = ease_func_in(abs(raw_value.x / max_offset)) * max_offset * get_sign(raw_value.x)
				self.position.y = ease_func_in(abs(raw_value.y / max_offset)) * max_offset * get_sign(raw_value.y)
			EaseModes.OUT:
				self.position.x = ease_func_in(abs(raw_value.x / max_offset)) * max_offset * get_sign(raw_value.x)
				self.position.y = ease_func_in(abs(raw_value.y / max_offset)) * max_offset * get_sign(raw_value.y)
			EaseModes.IN_OUT:
				self.position.x = ease_func_in_out(abs(raw_value.x / max_offset)) * max_offset * get_sign(raw_value.x)
				self.position.y = ease_func_in_out(abs(raw_value.y / max_offset)) * max_offset * get_sign(raw_value.y)
	
	else: # animate_to_bool
		
		# x
		if animation_raw_value.x < animate_to_global_position.x:
			animation_raw_value.x += animation_x_rate
			if animation_raw_value.x > animate_to_global_position.x:
				animation_raw_value.x = animate_to_global_position.x
		
		elif animation_raw_value.x > animate_to_global_position.x:
			animation_raw_value.x -= animation_x_rate
			if animation_raw_value.x < animate_to_global_position.x:
				animation_raw_value.x = animate_to_global_position.x
		
		# y
		if animation_raw_value.y < animate_to_global_position.y:
			animation_raw_value.y += animation_y_rate
			if animation_raw_value.y > animate_to_global_position.y:
				animation_raw_value.y = animate_to_global_position.y
		
		elif animation_raw_value.y > animate_to_global_position.y:
			animation_raw_value.y -= animation_y_rate
			if animation_raw_value.y < animate_to_global_position.y:
				animation_raw_value.y = animate_to_global_position.y
		
		# set actual position with ease_function
#		self.global_position.x = ease_func_in(abs(animation_raw_value.x / animate_to_global_position.x)) * animate_to_global_position.x * get_sign(animation_raw_value.x)
#		self.global_position.y = ease_func_in(abs(animation_raw_value.y / animate_to_global_position.y)) * animate_to_global_position.y * get_sign(animation_raw_value.y)
		self.global_position = animation_raw_value
		
		# test if camera is back on player
		if reset_bool and animation_raw_value.x == animate_to_global_position.x and animation_raw_value.y == animate_to_global_position.y:
			reset_bool = false
			animate_to_bool = false


func animate_to(global_position: Vector2):
	animate_to_bool = true
	animate_to_global_position = global_position
	animation_raw_value = self.global_position
	animation_save_global_camera_position = self.global_position
	
	var diff = Vector2(abs(global_position.x - self.global_position.x), abs(global_position.y - self.global_position.y)).normalized()
	animation_x_rate = (diff.x / diff.y) * animation_speed
	animation_y_rate = animation_speed


func reset_animate_position():
	animate_to(animation_save_global_camera_position)
	reset_bool = true
	raw_value = Vector2.ZERO
	drag_x = 0.0
	drag_y = 0.0
	current_state_x = MoveState.IDLE
	current_state_y = MoveState.IDLE
	prev_state_x = MoveState.IDLE
	prev_state_y = MoveState.IDLE


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
func ease_func_in_out(value: float) -> float:
	var ret_val: float = 0.0
	if value < 0.5:
		ret_val = 4 * value * value * value
	else:
		ret_val = 1 - pow(-2 * value + 2, 3) / 2
	return ret_val


func ease_func_in(value: float) -> float:
	return pow(value, 3)


func ease_func_out(value: float) -> float:
	return 1 - pow(1 - value, 3)

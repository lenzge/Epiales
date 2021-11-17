extends Enemy

#  for finding way back to his old patrol point
var position_cache

func _ready():
	# For detecting Patrol Points
	wall_detection_raycast.collide_with_areas = true
	

func windup_move(delta):
	move(windup_speed)

func patrol(delta):
	move(walk_speed)
	
func chase(delta):
	if floor_detection_raycast.is_colliding() and is_on_floor():
		move(running_speed)
	

func move(speed):
	# Turn when colliding with PatrolPoints
	if wall_detection_raycast.is_colliding():
		flip_direction()
	velocity.x = speed * direction
	velocity = move_and_slide(velocity, Vector2.UP)
	
func move_backwards(delta):
	var desired_velocity = (position_cache - global_position).normalized() * running_speed
	var steering = desired_velocity - velocity
	velocity = move_and_slide(velocity + steering, Vector2.UP)
	
func attack_move(delta, attack_chain) -> void:
	if not attack_chain: 
		velocity.x = attack_speed * direction
	else:
		velocity.x = running_speed * direction
	fall()
		
		
func drop_move(delta, target_position):
	velocity = Vector2(running_speed * direction, running_speed).normalized() * running_speed
	#var desired_velocity = (target_position - global_position).normalized() * running_speed
	#var steering = desired_velocity - velocity
	velocity = move_and_slide(velocity, Vector2.UP)


func knockback(delta, force, direction):
	velocity.x = force/2 * direction
	velocity = move_and_slide(velocity, Vector2.UP)
	#fall()


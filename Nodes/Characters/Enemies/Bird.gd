extends Enemy

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
	velocity.x = walk_speed * -direction
	velocity.y -= gravity / 6
	velocity = move_and_slide(velocity, Vector2.UP)
	
func attack_move(delta, attack_chain) -> void:
	if not attack_chain: 
		velocity.x = attack_speed * direction
	else:
		velocity.x = running_speed * direction
	fall()
		
		
func drop_move(delta):
	velocity.x = running_speed * direction
	velocity.y += gravity 
	velocity = move_and_slide(velocity, Vector2.UP)

func knockback(delta, force, direction):
	velocity.x = force * direction
	fall()


class_name Puppet
extends Enemy



func windup_move(delta):
	move(windup_speed)

func patrol(delta):
	move(walk_speed)
	
func chase(delta):
	if floor_detection_raycast.is_colliding() and is_on_floor():
		move(running_speed)
	
func fall():
	velocity.y += gravity
	velocity = move_and_slide(velocity, Vector2.UP)

func move(speed):
	# Turn automatically on cliffs 
	# _is_on_wall() cant't be used because of weird interactions with the player. Other solution
	if wall_detection_raycast.is_colliding() or not floor_detection_raycast.is_colliding() and is_on_floor():
		flip_direction()
	
	velocity.x = speed * direction
	fall()
	
func move_backwards(delta):
	# Turn automatically on cliffs and walls
	if is_on_wall() or not floor_detection_raycast.is_colliding() and is_on_floor():
		flip_direction()
	velocity.x = walk_speed * -direction
	fall()
	
func attack_move(delta, attack_chain) -> void:
	if not attack_chain: 
		velocity.x = attack_speed * direction
	else:
		velocity.x = running_speed * direction
	fall()
		



func knockback(delta, force, direction):
	velocity.x = force * -direction
	fall()


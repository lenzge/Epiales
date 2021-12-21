class_name Puppet
extends Enemy


func windup_move(delta):
	move(windup_speed)

func patrol(delta):
	move(walk_speed)
	
func chase(delta):
	move(running_speed)

func move(speed):
	# Turn automatically on cliffs 
	# _is_on_wall() cant't be used because of weird interactions with the player. Other solution
	if wall_detection_raycast.is_colliding() or not floor_detection_raycast.is_colliding() and is_on_floor():
		flip_direction()
	
	velocity.x = speed * direction
	fall()
	
func move_backwards(delta):
	if not floor_back_detection_raycast.is_colliding() and is_on_floor():
		return
	velocity.x = walk_speed * -direction
	fall()
	
func attack_move(delta, attack_chain) -> void:
	if not floor_detection_raycast.is_colliding() and is_on_floor():
		return
	if not attack_chain: 
		velocity.x = attack_speed * direction
	else:
		velocity.x = running_speed * direction
	fall()
		

func knockback(delta, force, direction):
	velocity.x = force * direction
	fall()

extends KinematicBody2D

var velocity = Vector2(0,0)

const SPEED = 150
const JUMPFORCE = -800
const GRAVITY = 30

func _physics_process(delta):
	
	# input
	if Input.is_action_pressed("move_right"):
		velocity.x = SPEED
		#$Sprite.play("walk")
		$AnimatedSprite.flip_h = false
	elif Input.is_action_pressed("move_left"):
		velocity.x = -SPEED
		#$Sprite.play("walk")
		$AnimatedSprite.flip_h = true
	#else:
		#$Sprite.play("idle")
		
	# jump animation
	#if not is_on_floor():
		#$Sprite.play("air")
		
	# gravity
	velocity.y += GRAVITY
	
	#jump (only if you are on a static collision body)
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMPFORCE
	
	# move, knows if there is a collision (y to 0), UP as direction
	velocity = move_and_slide(velocity, Vector2.UP)
	
	# stop moving slowly
	velocity.x = lerp(velocity.x, 0, 0.4)




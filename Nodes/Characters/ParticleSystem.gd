extends Sprite

# Searching a way, the sprite doesen't move with the player, while playing dash animation

var position_cache
var stop := false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func stop_moving():
	position_cache = global_position
	stop = true

func _physics_process(delta):
	if stop:
		global_position = position_cache
	
func move_to_player():
	stop = false



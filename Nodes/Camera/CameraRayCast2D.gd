extends RayCast2D


export var new_cast_to: Vector2


# Called when the node enters the scene tree for the first time.
func _ready():
	set_cast_to(new_cast_to)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

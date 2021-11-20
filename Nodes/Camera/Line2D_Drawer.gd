extends Line2D

# For debugging raycasts
onready var parent_raycast = get_parent()


# Called when the node enters the scene tree for the first time.
func _ready():
	set_as_toplevel(true)


func _process(delta):
	update()


func _draw():
	var line_color = Color(0, 0, 255)
	if(parent_raycast.get_cast_to().x < 0):
		line_color = Color(255, 0, 0)
	elif(parent_raycast.get_cast_to().x > 0):
		line_color= Color(0, 255, 0)
	draw_line(parent_raycast.position, parent_raycast.position + parent_raycast.get_cast_to(), line_color, 10.0, true)

extends Line2D


onready var parent_raycast = get_parent()


# Called when the node enters the scene tree for the first time.
func _ready():
	set_as_toplevel(true)


func _process(delta):
	update()


func _draw():
	#print("I am drawing")
	draw_line(parent_raycast.position, parent_raycast.position + parent_raycast.get_cast_to(), Color(0, 0, 255), 10.0, true)
	print(parent_raycast.get_cast_to())

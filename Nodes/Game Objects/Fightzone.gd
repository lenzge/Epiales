extends Node

var is_active =false
onready var left_barrier = get_node("LeftBarrier")
onready var right_barrier = get_node("RightBarrier")
var left_border_pos
var right_border_pos

# Called when the node enters the scene tree for the first time.
func _ready():
	var children = get_children()
	for child in children:
		if child.name.find("Barrier") != -1:
			child.connect("body_exited",self,"_on_Fightzone_exited")
			child.connect("body_entered",self,"_on_Barrier_touched")
	left_border_pos = left_barrier.global_position.x
	right_border_pos = right_barrier.global_position.x
	
func _on_Fightzone_exited(body):
#	print("[DEGUG @ Fightzone] position: ", body.position.x)
	
	if not is_active and body.name == "Player" and _is_within_borders(body.global_position.x):
		is_active = true
		right_barrier.spawn()
		left_barrier.spawn()

func _on_Barrier_touched(body):
	if is_active and body.name == "Player" or body.name is Enemy:
		right_barrier.get_node("Border/CollisionShape2D").set_deferred("disabled", false)
		left_barrier.get_node("Border/CollisionShape2D").set_deferred("disabled", false)
	
func _is_within_borders(position):
	return position < right_border_pos and left_border_pos < position 

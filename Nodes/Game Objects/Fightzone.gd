extends Node

var is_active =false
onready var left_barrier = get_node("LeftBarrier")
onready var right_barrier = get_node("RightBarrier")
var left_border_pos
var right_border_pos
var enemies = []

# Called when the node enters the scene tree for the first time.
func _ready():
	var children = get_children()
	for child in children:
		if child.name.find("Barrier") != -1:
			child.connect("body_exited",self,"_on_Fightzone_exited")
			child.connect("body_entered",self,"_on_Barrier_touched")
# replace by proper condition e.g. is Enemy!!
		if child.name.find("Puppet",0) != -1 or child.name.find("Bird",0) != -1 and child.name.find("Patrol",0) == -1: 
				enemies.append(child)

	left_border_pos = left_barrier.global_position.x
	right_border_pos = right_barrier.global_position.x
	
func _process(delta):
	if is_active and not enemies.empty():
		for enemy in enemies:
			if not is_instance_valid(enemy):
				enemies.remove(enemies.find(enemy,0))
			elif enemy.get_health() <= 0:
				enemies.remove(enemies.find(enemy,0))
				
	elif is_active and enemies.empty():
		is_active = false
		right_barrier.despawn()
		right_barrier.get_node("Border/CollisionShape2D").set_deferred("disabled", true)
		left_barrier.despawn()
		left_barrier.get_node("Border/CollisionShape2D").set_deferred("disabled", true)

## Will be notified by Barriers if Player passed
## Activates and spwans Barriers
func _on_Fightzone_exited(body):
	if not is_active and body.name == "Player" and _is_within_borders(body.global_position.x):
		is_active = true
		right_barrier.spawn()
		right_barrier.get_node("Border/CollisionShape2D").set_deferred("disabled", false)
		left_barrier.spawn()
		left_barrier.get_node("Border/CollisionShape2D").set_deferred("disabled", false)


## Will be notified by Barriers if Player or enemy ran into it
## Deals damage to either player or enemy and knocks back on touch
func _on_Barrier_touched(body):
	if is_active and body.name == "Player" or body.name is Enemy:
		pass
	
func _is_within_borders(position):
	return position < right_border_pos and left_border_pos < position 

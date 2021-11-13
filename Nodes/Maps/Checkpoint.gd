class_name Checkpoint
extends Area2D

signal _checkpoint_entered(spawnpoint, prio)

export var opt_spawn := NodePath()
export var prio : int = 0

var spawnpoint

func _ready():
	self.connect("area_entered", self , "_on_Self_area_entered")
	
	var opt_position = get_node(opt_spawn)
	if opt_position != null and opt_position is Position2D:
		spawnpoint = opt_position.position
	else:
		spawnpoint = self.position
	
	if owner != null and owner.name == "Level":
		self.connect("_checkpoint_entered", owner, "_on_Checkoint_checkoint_entered")
		
func _on_Self_area_entered(entered_object):
	if entered_object.owner.name == "Player":
		emit_signal("_checkpoint_entered",spawnpoint, prio)

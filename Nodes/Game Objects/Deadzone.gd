class_name Deadzone
extends Area2D

var level : HackNSlashLevel


func _ready():
	self.connect("body_entered", self, "player_touched")


func player_touched(body):
	if body is Player:
		body.increment_nightmare(body.nightmare_spikes_increment)
	level.reset()


func set_level_instance(level : HackNSlashLevel):
	self.level = level

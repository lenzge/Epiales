class_name Deadzone
extends Area2D

var level : HackNSlashLevel


func _ready():
	self.connect("body_entered", self, "player_touched")


func player_touched(body):
	level.reset()


func set_level_instance(level : HackNSlashLevel):
	self.level = level

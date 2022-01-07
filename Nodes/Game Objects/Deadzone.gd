class_name Deadzone
extends Area2D

signal player_touched()

export (int) var damage = 0
export (int) var fear = 0 

var level : HackNSlashLevel

func _ready():
	self.connect("body_entered", self, "player_touched")


func player_touched(entered_object):
	emit_signal("player_touched")


func set_level_instance(level : HackNSlashLevel):
	self.level = level

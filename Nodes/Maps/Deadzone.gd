extends Area2D

signal _player_entered_deadzone

func _ready():
	self.connect("area_entered", self, "_on_Self_area_entered")
	if owner != null and owner.name == "Level":
		self.connect("_player_entered_deadzone", owner, "_on_player_entered_deadzone")

func _on_Self_area_entered(entered_object):
	if entered_object.owner.name == "Player": #better Chek needed! check with "is Player"
		emit_signal("_player_entered_deadzone")



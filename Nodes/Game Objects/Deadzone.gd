extends Area2D

signal _player_entered_deadzone(dmg, fear)

export (int) var dealt_damage = 0
export (int) var dealt_fear = 0 

func _ready():
	self.connect("area_entered", self, "_on_Self_area_entered")
	self.connect("_player_entered_deadzone", owner, "_on_player_entered_deadzone")

func _on_Self_area_entered(entered_object):
	if entered_object.owner.name == "Player": #better Chek needed! check with "is Player"
		emit_signal("_player_entered_deadzone", dealt_damage, dealt_fear)

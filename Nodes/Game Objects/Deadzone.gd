extends Area2D

signal _player_entered_deadzone(dmg, fear)

#:symbolizes damage dealt do player \n alkndwa:
export (int, FLAGS) var dealt_damage = 0
export (int) var dealt_fear = 0 

func _ready():
	self.connect("body_entered", self, "_on_Self_area_entered")
	self.connect("_player_entered_deadzone", owner, "_on_player_entered_deadzone")

func _on_Self_area_entered(entered_object):
	if entered_object.name == "Player": #better Chek needed! check with "is Player"
		emit_signal("_player_entered_deadzone", dealt_damage, dealt_fear)

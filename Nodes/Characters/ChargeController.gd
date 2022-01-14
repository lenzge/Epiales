extends Control

## Controls the Chargepoints of the Player. 
## charge_points will be increased by successful blocking. Decreased by Charged Attacks/Dashes

var _charge_points = 0
var _max_charge_points = 3
var _progress_per_point : int = 100/_max_charge_points

onready var progress_bar = $TextureProgress


func has_charge():
	if _charge_points > 0:
		return true
	else:
		return false


func _on_blocked():
	if _charge_points < _max_charge_points:
		_charge_points += 1
		progress_bar.value += _progress_per_point

func _on_charged_action():
	_charge_points -= 1
	progress_bar.value -= _progress_per_point

extends Sprite

## Controls the Chargepoints of the Player. 
## charge_points will be increased by successful blocking. Decreased by Charged Attacks/Dashes

var _charge_points = 0
var _max_charge_points = 3

onready var cp1 = $ChargePoint
onready var cp2 = $ChargePoint2
onready var cp3 = $ChargePoint3

func _has_charge():
	if _charge_points > 0:
		return true
	else:
		return false


func _on_blocked():
	if _charge_points < _max_charge_points:
		_charge_points += 1
		
		match _charge_points:
			1:
				cp1.fill()
			2:
				cp2.fill()
			3:
				cp3.fill()
	owner.player.has_charge = _has_charge()

func _on_charged_action():
	match _charge_points:
			1:
				cp1.empty()
			2:
				cp2.empty()
			3:
				cp3.empty()
	_charge_points -= 1
	owner.player.has_charge = _has_charge()

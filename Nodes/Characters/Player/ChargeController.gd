extends Control

# Will be increased by successful blocking. Decreased by Charged Attacks/Dashes
var charge_points = 0
var max_charge_points = 3
onready var progress_bar = $TextureProgress


func _on_charged_action():
	charge_points -= 1
	progress_bar.value -=33

func _on_blocked():
	print("PLAYER: block")
	if charge_points < max_charge_points:
		charge_points += 1
		progress_bar.value +=33
	print(charge_points)

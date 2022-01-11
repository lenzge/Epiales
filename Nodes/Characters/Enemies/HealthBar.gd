extends Control

onready var health_under = $HealthUnder
onready var health_over = $HealthOver
onready var update_tween = $Tween

signal zero_hp

func get_damage(damage):
	health_over.value -= damage
	update_tween.interpolate_property(health_under, "value", health_under.value, health_over.value, 0.2, Tween.TRANS_SINE, Tween.EASE_IN_OUT, 0.4)
	update_tween.start()
	
	
func set_max_health(max_health):
	health_over.max_value = max_health
	health_over.value = max_health
	health_under.max_value = max_health
	health_under.value = max_health


func _on_Tween_tween_completed(object, key):
	if health_under.value <= 0:
		emit_signal("zero_hp")

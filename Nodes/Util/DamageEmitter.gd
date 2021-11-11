class_name DamageEmitter
extends Area2D

export var damagae_amount : int
export var knockback_force : float
export var knockback_time : float
#Direction in degrees
export var direction : float
export var is_directed : bool

signal block()
signal hit()

var is_consumed : bool

func _physics_process(delta):
	is_consumed = false
	


func block():
	if not is_consumed:
		is_consumed = true 
		emit_signal("block")


func hit():
	if not is_consumed:
		is_consumed = false
		emit_signal("hit")

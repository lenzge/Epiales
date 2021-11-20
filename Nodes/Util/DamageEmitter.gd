class_name DamageEmitter
extends Area2D

export var emitter_path : NodePath
export var damagae_amount : int
export var knockback_force : float
export var knockback_time : float
#Direction in degrees
export var direction : float
export var is_directed : bool

signal blocked(receiver)
signal hit(receiver)

var is_consumed : bool
var emitter : Node

func _ready():
	emitter = get_node(emitter_path)


func _physics_process(delta):
	is_consumed = false
	

func was_blocked(receiver):
	if not is_consumed:
		is_consumed = true 
		emit_signal("blocked", receiver)


func hit(receiver):
	if not is_consumed:
		is_consumed = false
		print(receiver, "hit with force:", knockback_force)
		emit_signal("hit", receiver)

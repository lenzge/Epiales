class_name DamageEmitter
extends Area2D

export var emitter_path : NodePath
export var damagae_amount : int
export var knockback_force : float
export var knockback_time : float
export var direction : Vector2

signal blocked(receiver)
signal hit(receiver)

var is_consumed : bool
var emitter : Node
var collision_shapes : Array = []

func _ready():
	emitter = get_node(emitter_path)
	for node in get_children():
		if node is CollisionPolygon2D or node is CollisionShape2D:
			collision_shapes.append(node)


func _physics_process(delta):
	is_consumed = false
	

func was_blocked(receiver):
	if not is_consumed:
		is_consumed = true 
		emit_signal("blocked", receiver)


func hit(receiver):
	if not is_consumed:
		is_consumed = false
		emit_signal("hit", receiver)


func set_disabled(disabled : bool ):
	if disabled:
		for collision_shape in collision_shapes:
			collision_shape.disabled = true
	else:
		for collision_shape in collision_shapes:
			collision_shape.disabled = false


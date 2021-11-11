class_name DamageReceiver
extends Area2D

signal on_hit_start(emitter)
signal on_hit_stop(emitter)

func _ready():
	self.connect("area_entered", self, "_on_hit_start")
	self.connect("area_exited", self, "_on_hit_stop")
	pass


func _on_hit_start(body : Node):
	if body is DamageEmitter:
		emit_signal("on_hit_start", body)


func _on_hit_stop(body : Node):
	if body is DamageEmitter:
		emit_signal("on_hit_stop", body)

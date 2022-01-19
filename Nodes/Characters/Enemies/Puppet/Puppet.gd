extends Node2D

export var attack_interval_min : float
export var attack_interval_max : float

var focused_player : Player = null setget set_focused_player, get_focused_player
var can_attack : bool = true
var is_registered_by_player : bool = false

var _rng : RandomNumberGenerator

func _ready():
	_rng = RandomNumberGenerator.new()
	_set_up()


func _process(delta):
	# Deal damage when not in dying state and when in range of player
	if $PuppetCharacter.is_focused and focused_player != null and \
	$PuppetCharacter/StateMachine.state.name != "Die" and !is_registered_by_player:
		focused_player.add_enemy_in_range()
		is_registered_by_player = true
	elif (!$PuppetCharacter.is_focused and is_registered_by_player) or \
	($PuppetCharacter.is_focused and is_registered_by_player and $PuppetCharacter/StateMachine.state.name == "Die"):
		focused_player.remove_enemy_in_range()
		is_registered_by_player = false


func set_can_attack(value : bool):
	can_attack = value


func set_focused_player(value):
	focused_player = value


func get_focused_player() -> Player:
	return focused_player


func switched_state(state_name):
	if ["Attack",  "AttackRun"].has(state_name):
		can_attack = false
		_rng.randomize()
		$AttackTimer.start(_rng.randf_range(attack_interval_min, attack_interval_max))


func on_died():
	queue_free()


func _set_up():
	$StateMachine.propagate_call("set_controlled_character", [$PuppetCharacter])
	$StateMachine.propagate_call("set_ai_controller", [self])


func on_hit(emitter : DamageEmitter):
	if(emitter.name == "Charged_Dash"):
		var node_path = emitter.emitter_path
		var player = get_node(node_path)
		var velocity : Vector2 = player.velocity
		state_machine.transition_to("Hit_by_charged_dash", {"velocity": velocity})
	else:
		# call supermethod on_hit
		.on_hit(emitter) 


func on_hit_stop(emitter : DamageEmitter):
	if(emitter.name == "Charged_Dash"):
		var time = emitter.knockback_time
		var direction = emitter.direction.x
		var force = emitter.knockback_force
		state_machine.transition_to("Stunned", {"time": time, "direction":direction, "force":force})


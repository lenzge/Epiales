class_name PuppetCharacter
extends Character

#Movement properties
export var walk_move_accel : float
export var run_move_accel : float
export var air_move_factor : float
export var focused_move_factor : float
export var backwards_focused_move_factor : float
export var attack_run_move_factor : float
export var attack_move_factor : float

#Attack properties
export(int, "GRAVITY", "CONSTANT") var attack_fall_mode : int
export var attack_constant_fall_speed : float
export(int, "ON_WINDUP", "ON_ATTACK", "ON_RECOVERY", "NEVER") var attack_y_velocity_reset : int
export(Array, float) var attack_damage
export(Array, float) var attack_force
export var attack_area_path : NodePath

#Flinch properties
export var flinch_intesity : float
export var flinch_air_factor : float
export var can_flinch_over_edge : bool

onready var attack_area : DamageEmitter = get_node(attack_area_path)
onready var healthbar = $HealthBar

var is_winding_up : bool
var is_focused : bool


func _ready():
	._ready()
	#healthbar.set_max_health(health)


func flip():
	.flip()
	attack_area.direction = Vector2(1, 0) if is_facing_right else Vector2(-1, 0)
	healthbar.rect_scale.x *= -1


func attack():
	if state_machine.state.has_method("on_attack"):
		state_machine.state.call("on_attack")


func on_hit(emitter : DamageEmitter):
	if(emitter.name == "Charged_Dash"):
		emitter.hit($"HitBox")
		var player = get_node(emitter.emitter_path)
		var velocity : Vector2 = player.velocity
		var direction = emitter.direction
		var force = emitter.knockback_force
		$StateMachine.transition_to("Hit_by_charged_dash", {"velocity": velocity, "direction":direction, "knockback_force":force})
	else:
		# call supermethod on_hit
		.on_hit(emitter) 
		healthbar.get_damage(emitter.damage_amount)


func on_hit_stop(emitter : DamageEmitter):
# zeit zählen und dann abhängig von zeit am Ende Schaden machen
	print("puppetcharacter: hit stop first")
	if(emitter.name == "Charged_Dash"):
		print("puppetcharacter: hit stop")
		var time = emitter.knockback_time
		var direction = emitter.direction.x
		var force = emitter.knockback_force
		$StateMachine.transition_to("Flinch", {"direction_x":direction})


func _set_up():
	._set_up()
	for child in $StateMachine.get_children():
		if "character" in child:
			child.character = self
	$HealthBar.set_max_health(max_health)
	$StateMachine/AttackWindUp.move_accel = attack_move_factor * walk_move_accel
	$StateMachine/Attack.move_accel = attack_move_factor * walk_move_accel
	$StateMachine/AttackRecovery.move_accel = attack_move_factor * walk_move_accel
	$StateMachine/AttackWindUp.fall_mode = attack_fall_mode
	$StateMachine/Attack.fall_mode = attack_fall_mode
	$StateMachine/AttackRecovery.fall_mode = attack_fall_mode
	$StateMachine/AttackWindUp.constant_fall_speed = attack_constant_fall_speed
	$StateMachine/Attack.constant_fall_speed = attack_constant_fall_speed
	$StateMachine/AttackRecovery.constant_fall_speed = attack_constant_fall_speed
	match(attack_y_velocity_reset):
		0:
			$StateMachine/AttackWindUp.should_reset_y_velocity = true
		1:
			$StateMachine/Attack.should_reset_y_velocity = true
		2:
			$StateMachine/AttackRecovery.should_reset_y_velocity = true
	$StateMachine/AttackRunRun.walk_move_accel = walk_move_accel * attack_run_move_factor
	$StateMachine/AttackRunRun.run_move_accel = run_move_accel * attack_run_move_factor
	$StateMachine/AttackFall.move_accel = walk_move_accel * attack_run_move_factor * air_move_factor
	$StateMachine/Attack.attack_damage = attack_damage
	$StateMachine/Attack.attack_force = attack_force
	$StateMachine/Attack.max_attack_combo = 2
	$StateMachine/Run.run_move_accel = run_move_accel
	$StateMachine/Run.walk_move_accel = walk_move_accel
	$StateMachine/Fall.move_accel = walk_move_accel * air_move_factor
	$StateMachine/Flinch.flinch_intensity = flinch_intesity
	$StateMachine/Flinch.air_factor = flinch_air_factor
	$StateMachine/Flinch.can_flinch_over_edge = can_flinch_over_edge
	$StateMachine/FocusedRun.run_move_accel = run_move_accel * focused_move_factor
	$StateMachine/FocusedRun.walk_move_accel = walk_move_accel * focused_move_factor
	$StateMachine/FocusedRun.backwards_factor = backwards_focused_move_factor


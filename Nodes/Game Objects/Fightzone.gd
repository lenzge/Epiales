extends Node

export (float) var spawn_delay = 0.5
export (float) var despawn_delay = 1.0
export (int) var barrier_dmg = 100

onready var left_barrier = get_node("LeftBarrier")
onready var right_barrier = get_node("RightBarrier")

var is_active =false
var left_border_pos
var right_border_pos
var enemies = []

var player = null
var entering_barrier = 0 # 0 = left_barrier, 1 = right_barrier

# Called when the node enters the scene tree for the first time.
func _ready():
	set_dmg(barrier_dmg)
	var children = get_children()
	for child in children:
		if child.name.find("Barrier") != -1:
			child.connect("body_exited",self,"_on_Fightzone_exited", [child])
			child.get_node("AnimationPlayer").connect("animation_started", self, "_on_Animation_finished")
			
		# replace by proper condition e.g. is Enemy!!
		if child.name.find("Puppet",0) != -1 or child.name.find("Bird",0) != -1 and child.name.find("Patrol",0) == -1: 
				enemies.append(child)

	left_border_pos = left_barrier.global_position.x
	right_border_pos = right_barrier.global_position.x
	
func _process(delta):
	## Check if enemies are still alive
	if is_active and not enemies.empty():
		for enemy in enemies:
			if not is_instance_valid(enemy):
				enemies.remove(enemies.find(enemy,0))
			elif enemy.get_health() <= 0:
				enemies.remove(enemies.find(enemy,0))
	#If no enemy remains inside fightzone despawn barriers
	elif is_active and enemies.empty():
		is_active = false
		if entering_barrier == 0:
			player.camera.animate_to(right_barrier.global_position)
		elif entering_barrier == 1:
			player.camera.animate_to(left_barrier.global_position)
		yield(player.camera, "animation_finished")
		right_barrier.despawn()
		right_barrier.get_node("Border/CollisionShape2D").set_deferred("disabled", true)
		right_barrier.get_node("DamageEmitter/CollisionShape2D2").set_deferred("disabled", true)
		left_barrier.despawn()
		left_barrier.get_node("Border/CollisionShape2D").set_deferred("disabled", true)
		left_barrier.get_node("DamageEmitter/CollisionShape2D2").set_deferred("disabled", true)
		get_tree().paused = true
		yield(get_tree().create_timer(despawn_delay), "timeout")
		get_tree().paused = false
		player.camera.reset_animate_position()
		MusicController.fade_out_music("OST_Hectic", 0.07)
		MusicController.fade_in_at_random("OST_Ominous")

## Will be notified by Barriers if Player passed
## Activates and spwans Barriers if player is still inside zone after certain delay
func _on_Fightzone_exited(body, emitter):
	if not is_active and body.name == "Player" and _is_within_borders(body.global_position.x) and not enemies.empty():
		
		if player == null:
			player = body
		
		var first_barrier
		var second_barrier
		
		if emitter.name == "LeftBarrier":
			entering_barrier = 0
			first_barrier = left_barrier
			second_barrier = right_barrier
		elif emitter.name == "RightBarrier":
			entering_barrier = 1
			first_barrier = right_barrier
			second_barrier = left_barrier
			
			
		is_active = true
		#Delay barrier activation
		yield(get_tree().create_timer(spawn_delay),"timeout")
		
		# Activate Fightzone Delay Barrier spawn
		if _is_within_borders(body.global_position.x):
			get_tree().paused = true
			MusicController.stop_everything(["Ambience_Atmosphere"])
			
			player.camera.animate_to(first_barrier.global_position)
			yield(player.camera, "animation_finished")
			first_barrier.spawn()
			first_barrier.sound_machine.play_sound("Spawn", false)
			yield(first_barrier.sound_machine, "sound_finished")
			
			player.camera.animate_to(second_barrier.global_position)
			yield(player.camera, "animation_finished")
			second_barrier.spawn()
			second_barrier.sound_machine.play_sound("Spawn", false)
			yield(second_barrier.sound_machine, "sound_finished")
			
			right_barrier.get_node("Border").set_collision_mask_bit(0,true)
			left_barrier.get_node("Border").set_collision_mask_bit(0,true)
			
			right_barrier.get_node("DamageEmitter/CollisionShape2D2").set_deferred("disabled", false)
			left_barrier.get_node("DamageEmitter/CollisionShape2D2").set_deferred("disabled", false)
			
			player.camera.reset_animate_position()
			yield(player.camera, "animation_finished")
			MusicController.play_music("OST_Hectic")
			get_tree().paused = false
		else:
			is_active = false

func _on_Animation_finished(anim_name:String):
#	if anim_name == "Idle":
#		get_tree().paused = false
	pass

func _is_within_borders(position):
	var guenther = left_border_pos < position and position < right_border_pos
	return guenther 

func set_dmg(dmg):
	left_barrier.get_node("DamageEmitter").damage_amount = dmg
	right_barrier.get_node("DamageEmitter").damage_amount = dmg

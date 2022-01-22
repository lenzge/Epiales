extends Node

export (float) var spawn_delay = 0.5
export (int) var barrier_dmg = 100

onready var left_barrier = get_node("LeftBarrier")
onready var right_barrier = get_node("RightBarrier")

var is_active =false
var left_border_pos
var right_border_pos
var enemies = []

# Called when the node enters the scene tree for the first time.
func _ready():
	set_dmg(barrier_dmg)
	var children = get_children()
	for child in children:
		if child.name.find("Barrier") != -1:
			child.connect("body_exited",self,"_on_Fightzone_exited")
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
		right_barrier.despawn()
		right_barrier.get_node("Border/CollisionShape2D").set_deferred("disabled", true)
		right_barrier.get_node("DamageEmitter/CollisionShape2D2").set_deferred("disabled", true)
		left_barrier.despawn()
		left_barrier.get_node("Border/CollisionShape2D").set_deferred("disabled", true)
		left_barrier.get_node("DamageEmitter/CollisionShape2D2").set_deferred("disabled", true)
		MusicController.fade_out_music("OST_Hectic")
		MusicController.fade_in_at_random("OST_Ominous")

## Will be notified by Barriers if Player passed
## Activates and spwans Barriers if player is still inside zone after certain delay
func _on_Fightzone_exited(body):
	if not is_active and body.name == "Player" and _is_within_borders(body.global_position.x) and not enemies.empty():
		is_active = true
		#Delay barrier activation
		yield(get_tree().create_timer(spawn_delay),"timeout")
		
		# Activate Fightzone Delay Barrier spawn
		if _is_within_borders(body.global_position.x):
			get_tree().paused = true
			MusicController.stop_everything(["Ambience_Atmosphere"])
			right_barrier.spawn()

			body.camera.animate_to(right_barrier.global_position)
			right_barrier.sound_machine.play_sound("Spawn", false)
			yield(right_barrier.sound_machine, "sound_finished")
			
			left_barrier.spawn()
			left_barrier.sound_machine.play_sound("Spawn", false)
			body.camera.animate_to(left_barrier.global_position)
			yield(left_barrier.sound_machine, "sound_finished")
			
			right_barrier.get_node("Border").set_collision_mask_bit(0,true)
			left_barrier.get_node("Border").set_collision_mask_bit(0,true)
			
			right_barrier.get_node("DamageEmitter/CollisionShape2D2").set_deferred("disabled", false)
			left_barrier.get_node("DamageEmitter/CollisionShape2D2").set_deferred("disabled", false)
			
			body.camera.reset_animate_position()
			MusicController.play_music("OST_Hectic")
		else:
			is_active = false

func _on_Animation_finished(anim_name:String):
	if anim_name == "Idle":
		get_tree().paused = false

func _is_within_borders(position):
	var guenther = left_border_pos < position and position < right_border_pos
	return guenther 

func set_dmg(dmg):
	left_barrier.get_node("DamageEmitter").damage_amount = dmg
	right_barrier.get_node("DamageEmitter").damage_amount = dmg

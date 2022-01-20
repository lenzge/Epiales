extends DamageReceiver

onready var sound_machine : SoundMachine = $SoundMachine
onready var animationPlayer : AnimationPlayer = $AnimationPlayer
export(bool) var is_active = true
export (int) var durability = 10

func _ready():
	self.connect("on_hit_start", self, "_on_Self_hit")
	owner.connect("level_reset", self, "_on_level_reset")
	animationPlayer.animation_set_next("Spawn", "Idle")
	animationPlayer.animation_set_next("Destroy", "Spawn")
	animationPlayer.play("Spawn")
	

func _on_level_reset():
	animationPlayer.play("Spawn")
	is_active = true

func _set_active():
	is_active = true


func _play_sound_reappear():
	sound_machine.play_sound("Orb_Reappearing", false)


func _on_Self_hit(body):
	if (body.name =="Attack" or body.name == "Attack_Up_Ground" or \
	body.name == "Attack_Down_Ground" or body.name == "Attack_Up_Air" or \
	body.name == "Attack_Down_Air") && body.owner.name == "Player": #better Chek needed! check with "is Player"
		reduce_durability(body.damage_amount)
		

func reduce_durability(dmg):
	durability -= dmg
	if(is_active and durability <= 0):
		owner.player_instance.can_dash = true
		is_active = false
		animationPlayer.play("Destroy")
		sound_machine.play_sound("Orb", false)
#		owner.remove_child(self) #leave inside child tree in case of a level reset
#		self.queue_free() #leave inside child tree in case of a level reset

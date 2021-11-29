extends DamageReceiver

export (int) var durability = 21

func _ready():
	self.connect("on_hit_start", self, "_on_Self_hitted")

func _on_Self_hitted(body):
	if body.name =="Attack" && body.owner.name == "Player": #better Chek needed! check with "is Player"
		reduce_durability(body.damage_amount)
		

func reduce_durability(dmg):
	durability -= dmg
	if(durability <= 0):
		owner.player_instance.can_dash = true
		self.visible = false
		owner.remove_child(self)
		self.queue_free()

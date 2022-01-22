extends Control

var player

onready var bar = $TextureProgress


func init(p_player):
	player = p_player
	player.connect("nightmare_changed", self, "_on_nightmare_change")
	player.connect("blocked", $Chargepoints, "_on_blocked")
	player.connect("charged_action", $Chargepoints, "_on_charged_action")

func _on_nightmare_change():
	bar.value = (float(player.nightmare) / float(player.max_nightmare)) * 100.0

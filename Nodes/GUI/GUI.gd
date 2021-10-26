extends Control


onready var nightmare_bar = $NightmareBar/TextureProgress
onready var tween = $Tween # TODO: animate bar using tween


# Called when the node enters the scene tree for the first time.
func _ready():
	nightmare_bar.value = 0
	nightmare_bar.max_value = 1000
	# Replace with proper initialization.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	nightmare_bar.value = min(nightmare_bar.value + 1, nightmare_bar.max_value)
	# Replace with proper functionality


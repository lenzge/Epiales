extends Control


const ANIMATION_METER_CHANGE_DURATION = 0.25

onready var nightmare_bar = $NightmareBar/TextureProgress
onready var tween = $Tween

var animated_meter = 0
var nightmare_meter_delta = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	nightmare_bar.value = 0
	nightmare_bar.max_value = 100
	# Replace with proper initialization.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	nightmare_bar.value = animated_meter
	
	if Input.is_action_pressed("ui_accept"):
		update_nightmare_meter(50)
	
	animated_meter = min(animated_meter + nightmare_meter_delta, nightmare_bar.max_value)
	
	
#func _on_nightmare_meter_changed(value_change):
	#update_nightmare_meter(value_change)
	
	
func update_nightmare_meter(new_value):
	tween.interpolate_property(self, "animated_meter", animated_meter, new_value, ANIMATION_METER_CHANGE_DURATION, Tween.TRANS_LINEAR, Tween.EASE_IN)
	if not tween.is_active():
		tween.start()
		

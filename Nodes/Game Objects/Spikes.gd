extends Deadzone

export (float) var deadly_time = 2

onready var timer = $Timer

func _ready():
	timer.start(deadly_time)

func switch_state():
	visible = !visible
	call_deferred("set_monitoring", !monitoring)

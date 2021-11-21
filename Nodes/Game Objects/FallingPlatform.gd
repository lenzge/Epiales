tool
extends StaticBody2D

#
# WARNING: This script uses tool mode!
# Tool mode can be disabled with the "update_in_editor" variable
# Tool mode is used that the size and texture changes are visible in the editor
# So it is recommended to turn tool mode off if no changes take place
#
# To change see changes that were made in the tilemap scene please save this scene
# or the Scene with the tilemap
#

var velocity := Vector2(0, 0)
var player_in_area : bool = false
var in_fall_process : bool = false
var shaking : bool = false
var falling : bool = false
var disappear : bool = false
var player : Player
var modulation : float = 1.0

export var graphic_path : NodePath
export var size := Vector2(16, 16)
export var time_to_fall : float = 0.5
export var time_to_disappear : float = 0.5
export var gravity : float = 100
export(float, 0.1, 10.0) var disappear_speed = 0.1
export var shakiness : float = 1

onready var graphic = get_node(graphic_path)

func _ready():
	# create a dedicated shape for every instance
	var shape_collision = $CollisionShape2D.shape.duplicate()
	shape_collision.extents = size
	$CollisionShape2D.shape = shape_collision
	var shape_detection = $Player_Detector/CollisionShape2D.shape.duplicate()
	shape_detection.extents = Vector2(size.x, 2)
	$Player_Detector/CollisionShape2D.shape = shape_detection
	$Player_Detector.position.y = -size.y


func _process(delta):
	if Engine.editor_hint:
		update_editor()


func _physics_process(delta):
	if not Engine.editor_hint:
		if in_fall_process:
			if shaking and shakiness > 0:
				var positionX = shakiness * sin(OS.get_ticks_msec())
				var positionY = shakiness * sin(OS.get_ticks_usec())
				graphic.position += Vector2(positionX, positionY)
			else:
				if falling:
					if !$CollisionShape2D.disabled or !$Player_Detector/CollisionShape2D.disabled:
						$CollisionShape2D.disabled = true
						$Player_Detector/CollisionShape2D.disabled = true
					self.position.y += gravity * delta
				if disappear:
					if graphic:
						graphic.modulate.a -= disappear_speed
					modulation -= disappear_speed
					if modulation <= 0.0:
						self.queue_free()
		elif player_in_area and player.is_on_floor():
			$Timer_StartFalling.start(time_to_fall)
			shaking = true
			in_fall_process = true


func _on_Player_Detector_body_entered(body):
	if body is Player:
		player_in_area = true
		player = body


func _on_Player_Detector_body_exited(body):
	if body == player:
		player_in_area = false
		player = null


func _on_Timer_StartFalling_timeout():
	$Timer_StartFalling.stop()
	falling = true
	shaking = false
	$Timer_Disapear.start(time_to_disappear)


func _on_Timer_Disapear_timeout():
	$Timer_Disapear.stop()
	disappear = true


func update_editor():
	# Change the size of the collision shapes
	$CollisionShape2D.shape.extents = size
	$Player_Detector/CollisionShape2D.shape.extents.x = size.x
	$Player_Detector/CollisionShape2D.shape.extents.y = 2
	$Player_Detector.position.y = -size.y

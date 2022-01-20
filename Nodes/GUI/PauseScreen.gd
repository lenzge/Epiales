extends CanvasLayer


onready var animationPlayer = $AnimationPlayer
onready var control_elements : int = $Control.get_child_count()

var visible : bool = false setget set_visible, is_visible
var focus_color : Color = Color(1.0, 0.0, 0.0, 1.0)
var unfocus_color : Color = Color(1.0, 1.0, 1.0, 1.0)
var in_pause_screen : bool = false

signal close_finished
signal resume_game

func _ready():
	get_tree().root.connect("size_changed", self, "center")
	center()


func _process(delta):
	if Input.is_action_just_pressed("ui_cancel") and in_pause_screen:
		$Control/Button_Continue.emit_signal("pressed")


func _on_close_timeout():
	emit_signal("close_finished")
	animationPlayer.stop()


func center():
	var background = $Background
	var controls = $Control
	
	background.scale = (OS.get_real_window_size() / background.texture.get_width())
	background.set_position(Vector2.ZERO)
	
	var controls_scale = OS.get_real_window_size() / OS.get_screen_size()
	controls.rect_scale = controls_scale
	
	for item in controls.get_children():
		var position = Vector2((OS.get_screen_size().x / 2) - (item.rect_size.x / 2), item.rect_position.y)
		item.rect_position = position


func set_visible(value: bool):
	visible = value
	for item in self.get_children():
		if item is CanvasItem:
			item.visible = value
	center()
	$Control/Music/Slider_Music.grab_focus()

func is_visible() -> bool:
	return visible


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Open":
		animationPlayer.play("Idle")
		in_pause_screen = true


func _on_Button_Continue_pressed():
	in_pause_screen = false
	emit_signal("resume_game")


func _on_Slider_Music_focus_entered():
	$Control/Music/Label_Music.modulate = focus_color


func _on_Slider_Music_focus_exited():
	$Control/Music/Label_Music.modulate = unfocus_color


func _on_Slider_SFX_focus_entered():
	$Control/SFX/Label_SFX.modulate = focus_color


func _on_Slider_SFX_focus_exited():
	$Control/SFX/Label_SFX.modulate = unfocus_color

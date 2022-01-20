extends Node2D


onready var animationPlayer = $AnimationPlayer
onready var menu_change_player = $Menu_change

var _rng = RandomNumberGenerator.new()

var in_options : bool = false
var focus_color : Color = Color(1.0, 0, 0, 1.0)
var unfocus_color : Color = Color(1.0, 1.0, 1.0, 1.0)

signal start_game
signal close_finished

func _ready():
	get_tree().root.connect("size_changed", self, "center")
	animationPlayer.play("Idle")
	
	$Control/Controls_Menu/Play_Button.grab_focus()


func _process(delta):
	if Input.is_action_pressed("ui_accept"):
		var pressed = false
		for btn in $Control/Controls_Menu.get_children():
			if btn.has_focus() and !pressed:
				btn.pressed = true
				pressed = true


func _on_close_timeout():
	emit_signal("close_finished")


func _on_AnimationPlayer_animation_finished(anim_name):
	var _animation = _rng.randi_range(1,3)
	if _animation == 1:
		animationPlayer.play("Idle")
	elif _animation == 2:
		animationPlayer.play("Blink")
	elif _animation == 3:
		animationPlayer.play("Look_Around")


# center ui on resize event
func center():
	var back = $Black_background
	var eyes = $Eyes
	var controls = $Control
	var controls_menu = $Control/Controls_Menu
	var controls_options = $Control/Controls_Options
	
	#self.scale = Vector2(OS.get_real_window_size().x / eyes.texture.get_width(), OS.get_real_window_size().x / eyes.texture.get_width())
	self.position = OS.get_real_window_size() / 2
	
	back.scale = (OS.get_real_window_size() / back.texture.get_width()) #/ self.scale
	back.set_position(Vector2.ZERO)
	
	controls_menu.rect_size = OS.get_real_window_size()
	controls_menu.rect_position = Vector2.ZERO
	if in_options:
		controls_menu.rect_position.x = -(OS.get_real_window_size().x + controls_menu.rect_size.x)
	
	controls_options.rect_size = OS.get_real_window_size()
	controls_options.rect_position = Vector2.ZERO
	if !in_options:
		controls_options.rect_position.x = OS.get_real_window_size().x + controls_options.rect_size.x
	
	# change the values in the AnimationPlayer
	if menu_change_player:
		var to_options_animation = menu_change_player.get_animation("to_Options")
		var to_menu_animation = menu_change_player.get_animation("to_Menu")
		var credits_animation = menu_change_player.get_animation("credits")
		
		to_options_animation.track_set_key_value(to_options_animation.find_track("Control/Controls_Menu:rect_position"), 1, Vector2(-OS.get_real_window_size().x * controls_menu.rect_size.x, controls_menu.rect_position.y))
		to_options_animation.track_set_key_value(to_options_animation.find_track("Control/Controls_Options:rect_position"), 0, Vector2(OS.get_real_window_size().x * controls_options.rect_size.x, controls_options.rect_position.y))
		
		to_menu_animation.track_set_key_value(to_menu_animation.find_track("Control/Controls_Menu:rect_position"), 0, Vector2(-OS.get_real_window_size().x * controls_menu.rect_size.x, controls_menu.rect_position.y))
		to_menu_animation.track_set_key_value(to_menu_animation.find_track("Control/Controls_Options:rect_position"), 1, Vector2(OS.get_real_window_size().x * controls_options.rect_size.x, controls_options.rect_position.y))
		
		credits_animation.track_set_key_value(credits_animation.find_track("Credits:rect_position"), 0, Vector2(-OS.get_real_window_size().x / 2, OS.get_real_window_size().y))
		credits_animation.track_set_key_value(credits_animation.find_track("Credits:rect_position"), 1, Vector2(-OS.get_real_window_size().x / 2, -(OS.get_real_window_size().y + $Credits.rect_size.y)))


func disable_buttons(value: bool):
	for item in $Control/Controls_Menu.get_children():
		if item is Button:
			item.disabled = value
	for item in $Control/Controls_Options.get_children():
		if item is Button:
			item.disabled = value


func _on_Play_Button_pressed():
	emit_signal("start_game")


func _on_Options_Button_pressed():
	in_options = true
	menu_change_player.play("to_Options")


func _on_Back_Button_pressed():
	in_options = false
	menu_change_player.play("to_Menu")


func _on_Exit_Button_pressed():
	get_tree().quit()


func _on_Credits_Button_pressed():
	menu_change_player.play("credits")


func _on_Slider_Music_focus_entered():
	$Control/Controls_Options/Label_Music.modulate = focus_color


func _on_Slider_Music_focus_exited():
	$Control/Controls_Options/Label_Music.modulate = unfocus_color


func _on_Slider_SFX_focus_entered():
	$Control/Controls_Options/Label_SFX.modulate = focus_color


func _on_Slider_SFX_focus_exited():
	$Control/Controls_Options/Label_SFX.modulate = unfocus_color


func _on_Menu_change_animation_finished(anim_name):
	if anim_name == "to_Options" or anim_name == "credits":
		$Control/Controls_Options/Slider_Music.grab_focus()
	elif anim_name == "to_Menu":
		$Control/Controls_Menu/Play_Button.grab_focus()

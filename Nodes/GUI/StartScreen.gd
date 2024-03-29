extends Node2D


onready var animationPlayer = $AnimationPlayer
onready var menu_change_player = $Menu_change
onready var sound_machine : SoundMachine = $SoundMachine

var _rng = RandomNumberGenerator.new()
var in_options : bool = false

signal start_game
signal close_finished

func _ready():
	get_tree().root.connect("size_changed", self, "center")
	animationPlayer.play("Idle")
	
	$Control/Controls_Menu/Play_Button.grab_focus()
	
	for item in $Control/Controls_Menu.get_children():
		if item is Button:
			item.get("custom_styles/focus").border_color = Globals.UI_FOCUSED_COLOR
	for item in $Control/Controls_Options.get_children():
		if item is Button:
			item.get("custom_styles/focus").border_color = Globals.UI_FOCUSED_COLOR


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


func load_sliders():
	$Control/Controls_Options/Slider_Music.value = ((MusicController.get_music_volume() + Globals.VOLUME_DB_RANGE) / Globals.VOLUME_DB_RANGE) * $Control/Controls_Options/Slider_Music.max_value
	$Control/Controls_Options/Slider_SFX.value = ((MusicController.get_sound_volume() + Globals.VOLUME_DB_RANGE) / Globals.VOLUME_DB_RANGE) * $Control/Controls_Options/Slider_SFX.max_value

# center ui on resize event
func center():
	var back = $Black_background
	var eyes = $Eyes
	var controls = $Control
	var controls_menu = $Control/Controls_Menu
	var controls_options = $Control/Controls_Options
	var controler_inputs = $ControllerInputs
	
	#self.scale = Vector2(OS.get_real_window_size().x / eyes.texture.get_width(), OS.get_real_window_size().x / eyes.texture.get_width())
	self.scale = OS.get_real_window_size() / OS.get_screen_size()
	self.position = OS.get_real_window_size() / 2
	
	back.scale = (OS.get_screen_size() / back.texture.get_width()) #/ self.scale
	back.set_position(Vector2.ZERO)
	
	controler_inputs.position = Vector2(-(OS.get_screen_size().x / 2) + (OS.get_screen_size().x / 16), (OS.get_screen_size().y / 2) - (OS.get_screen_size().y / 8))
	
	controls_menu.rect_size = OS.get_screen_size()
	controls_menu.rect_position = Vector2.ZERO
	if in_options:
		controls_menu.rect_position.x = -(OS.get_screen_size().x + controls_menu.rect_size.x)
	
	controls_options.rect_size = OS.get_screen_size()
	controls_options.rect_position = Vector2.ZERO
	if !in_options:
		controls_options.rect_position.x = OS.get_screen_size().x + controls_options.rect_size.x
	
	# change the values in the AnimationPlayer
	if menu_change_player:
		var to_options_animation = menu_change_player.get_animation("to_Options")
		var to_menu_animation = menu_change_player.get_animation("to_Menu")
		var credits_animation = menu_change_player.get_animation("credits")
		
		to_options_animation.track_set_key_value(to_options_animation.find_track("Control/Controls_Menu:rect_position"), 1, Vector2(-OS.get_screen_size().x * controls_menu.rect_size.x, controls_menu.rect_position.y))
		to_options_animation.track_set_key_value(to_options_animation.find_track("Control/Controls_Options:rect_position"), 0, Vector2(OS.get_screen_size().x * controls_options.rect_size.x, controls_options.rect_position.y))
		
		to_menu_animation.track_set_key_value(to_menu_animation.find_track("Control/Controls_Menu:rect_position"), 0, Vector2(-OS.get_screen_size().x * controls_menu.rect_size.x, controls_menu.rect_position.y))
		to_menu_animation.track_set_key_value(to_menu_animation.find_track("Control/Controls_Options:rect_position"), 1, Vector2(OS.get_screen_size().x * controls_options.rect_size.x, controls_options.rect_position.y))
		
		credits_animation.track_set_key_value(credits_animation.find_track("Credits:rect_position"), 0, Vector2(-OS.get_screen_size().x / 2, OS.get_screen_size().y))
		credits_animation.track_set_key_value(credits_animation.find_track("Credits:rect_position"), 1, Vector2(-OS.get_screen_size().x / 2, -(OS.get_screen_size().y + $Credits.rect_size.y)))


func disable_buttons(value: bool):
	for item in $Control/Controls_Menu.get_children():
		if item is Button:
			item.disabled = value
	for item in $Control/Controls_Options.get_children():
		if item is Button:
			item.disabled = value


func _on_Play_Button_pressed():
	MusicController.fade_out_music("OST_MENU", 0.2)
	sound_machine.play_sound("UI_enter", false)
	emit_signal("start_game")


func _on_Options_Button_pressed():
	in_options = true
	menu_change_player.play("to_Options")


func _on_Back_Button_pressed():
	in_options = false
	menu_change_player.play("to_Menu")


func _on_Exit_Button_pressed():
	JavaScript.eval("parent.click_back()")
	get_tree().quit()


func _on_Credits_Button_pressed():
	menu_change_player.play("credits")


func _on_Slider_Music_focus_entered():
	$Control/Controls_Options/Label_Music.modulate = Globals.UI_FOCUSED_COLOR


func _on_Slider_Music_focus_exited():
	$Control/Controls_Options/Label_Music.modulate = Globals.UI_UNFOCUSED_COLOR


func _on_Slider_SFX_focus_entered():
	$Control/Controls_Options/Label_SFX.modulate = Globals.UI_FOCUSED_COLOR


func _on_Slider_SFX_focus_exited():
	$Control/Controls_Options/Label_SFX.modulate = Globals.UI_UNFOCUSED_COLOR


func _on_Menu_change_animation_finished(anim_name):
	if anim_name == "to_Options" or anim_name == "credits":
		$Control/Controls_Options/Slider_Music.grab_focus()
	elif anim_name == "to_Menu":
		$Control/Controls_Menu/Play_Button.grab_focus()


func _on_Slider_Music_value_changed(value):
	var new_value = -Globals.VOLUME_DB_RANGE + ((value / $Control/Controls_Options/Slider_Music.max_value) * Globals.VOLUME_DB_RANGE)
	MusicController.set_music_volume(new_value)


func _on_Slider_SFX_value_changed(value):
	var new_value = -Globals.VOLUME_DB_RANGE + ((value / $Control/Controls_Options/Slider_Music.max_value) * Globals.VOLUME_DB_RANGE)
	MusicController.set_sound_volume(new_value)


func _on_focus_sound():
	sound_machine.play_sound("UI_click", false)

extends Node2D


func _ready():
	get_tree().root.connect("size_changed", self, "center")


func center():
	var texture = $black_texture
	var logo = $Logo
	var label = $Label
	
	texture.scale = OS.get_real_window_size() / texture.texture.get_width()
	texture.set_position(Vector2.ZERO)
	
	var logo_scale = Vector2(OS.get_real_window_size().x / logo.texture.get_width(), OS.get_real_window_size().x / logo.texture.get_width())
	logo.scale = logo_scale / 4
	var logo_dimensions = Vector2(logo.texture.get_width() * logo.scale.x, logo.texture.get_height() * logo.scale.y)
	logo.set_position((OS.get_real_window_size() / 2) - (logo_dimensions / 2))
	
	var label_scale = Vector2(OS.get_real_window_size().x / label.rect_size.x, OS.get_real_window_size().x / label.rect_size.x)
	label.rect_scale = label_scale / 1.5
	var label_dimensions = Vector2(label.rect_size.x * label.rect_scale.x, label.rect_size.y * label.rect_scale.y)
	label.set_position((OS.get_real_window_size() / 2) - (label_dimensions / 2))

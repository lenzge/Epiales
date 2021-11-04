extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	for button in $MarginContainer/ButtonContainer.get_children():
		
		if(not button.scene_to_load):
			button.disabled = true
		else:
			button.disabled = false
			button.connect("pressed", self, "_on_Button_pressed", [button.scene_to_load])


func _on_Button_pressed(scene_to_load):
	if scene_to_load == "Quit": 
		get_tree().quit()
	else:
		get_tree().change_scene(scene_to_load)

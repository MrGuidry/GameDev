extends Control

# ---------------------------------------
# Description:
# Welcome Scene methods
# 
# First Scene of game
#-----------------------------------------

func _ready():
	for button in $menu/center/buttons.get_children():
		print(button.scene_to_load)
		button.connect("pressed", self,"_on_button_pressed", [button.scene_to_load])

# Button pressed includes: "newGame", "newHardcore" buttons
func _on_button_pressed(scene_to_load): 
	get_tree().change_scene(scene_to_load)

func _on_newHardcore_pressed():
	Global.variant = true # Varient Mode activated.

extends Control

# --------------------------------------------------------------------------
# Methods Pertaining to the 'rules' scene:

# Upon the "continue" button is pressed when entering the "rules" scene
func _on_Button_pressed():
	get_tree().change_scene("res://galaga.tscn")

#---------------------------------------------------------------------------
# Methods pertaining to the 'game over' scene

# Sets to new game, reinitializes all global variables. 
func _on_playAgain_pressed():
	Global.multi = 1001
	
	Global.score=0
	Global.lives=100
	
	Global.variant = false
	Global.timer = 0
	get_tree().change_scene("res://welcome.tscn")

# Set the score of the game over screen.
func _on_gameOver_ready():
	var final_score_label = get_node("final_score_label")
	var finalScoreString = "Final Score: " + (str(Global.score))
	final_score_label.set_text(finalScoreString)

#---------------------------------------------------------------------------

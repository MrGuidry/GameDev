extends Control

func _on_Button_pressed():
	get_tree().change_scene("res://Node2D.tscn")


func _on_playAgain_pressed():
	Global.score=0
	Global.lives=100
	Global.respawned = true
	Global.multi = 1001
	Global.variant = false
	get_tree().change_scene("res://welcome.tscn")

func _on_gameOver_ready():
	var final_score_label = get_node("final_score_label")
	var finalScoreString = "Final Score: " + (str(Global.score))
	final_score_label.set_text(finalScoreString)

extends Control

func _on_Button_pressed():
	get_tree().change_scene("res://Node2D.tscn")


func _on_playAgain_pressed():
	get_tree().change_scene("res://welcome.tscn")



onready var final_score_label = get_node("final_score_label")
func _on_gameOver_ready():
	var finalScoreString = "Final Score: " + (str(Global.score))
	final_score_label.set_text(finalScoreString)

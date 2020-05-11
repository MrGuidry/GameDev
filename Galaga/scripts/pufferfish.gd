extends Area2D
signal on_Hit

func _ready():
	pass
	
func _process(delta):
	if(position.y >= 1000):
		queue_free()
	position.y += 2
	

func _on_pufferfish_body_entered(body):
	Global.lives -= 30
	emit_signal("on_Hit")
	queue_free()

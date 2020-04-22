extends Node2D

onready var movement = get_node("movement")
onready var death = get_node("death")
signal enemy_killed

func _ready():
	_init_tween()
	death.interpolate_property(self, 'scale', get_scale(), Vector2(0, 0), 0.1, Tween.TRANS_QUAD, Tween.EASE_OUT)
	death.interpolate_property(self, 'opacity',1, 0, 0.1,Tween.TRANS_QUAD, Tween.EASE_OUT)
	

func _init_tween():
	movement.interpolate_property(self, 'position', get_position(), Vector2(position.x+75,position.y),3,Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	movement.interpolate_property(self, 'position', Vector2(position.x+75,position.y), get_position(),3,Tween.TRANS_SINE, Tween.EASE_IN_OUT,3)
	movement.start()

func _on_Enemy_body_entered(body):
	print(body.get_name())
	emit_signal("enemy_killed")
	death.start()
	queue_free()


func _on_Enemy_area_entered(area):
	emit_signal("enemy_killed")
	death.start()
	queue_free()

extends Node2D

onready var movement = get_node("movement")
onready var death = get_node("death")
signal enemy_killed

func _ready():
	_init_tween()
	death.interpolate_property(self, 'scale', get_scale(), Vector2(0, 0), 0.3, Tween.TRANS_QUAD, Tween.EASE_OUT)
	

func _init_tween():
	movement.interpolate_property(self, 'position', get_position(), Vector2(position.x+75,position.y),3,Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	movement.interpolate_property(self, 'position', Vector2(position.x+75,position.y), get_position(),3,Tween.TRANS_SINE, Tween.EASE_IN_OUT,3)
	movement.start()

func _on_Enemy_body_entered(body):
	#if body.get_name() == 'Projectile':
	emit_signal("enemy_killed")
	death.start()
	$HitSound.play()
	yield ($HitSound, "finished")
	queue_free()


extends Area2D

signal player_hit
var speed

func _ready():
	pass
	
func _process(delta):
	if(position.y >= 1000):
		queue_free()
	position.y += speed
	
func _on_Projectile_area_entered(area):
	queue_free()

func _on_EnemyProjectile_body_entered(body):
	if(!Global.powerInvincible):
		emit_signal("player_hit")
	queue_free()

func set_fall_speed(s):
	speed = s

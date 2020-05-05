
extends Area2D

signal player_hit

func _ready():
	pass
	
func _process(delta):
	if(position.y >= 1000):
		queue_free()
	position.y += 6
	
func _on_Projectile_area_entered(area):
	queue_free()

func _on_EnemyProjectile_body_entered(body):
	if(!Global.powerInvincible):
		emit_signal("player_hit")
	queue_free()


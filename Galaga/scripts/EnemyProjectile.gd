#extends KinematicBody2D
#
#var velocity = Vector2()
#
#
#func _ready():
#	velocity.y = -400
#
#
#func _process(delta):
#	if(position.y < -700):
#		queue_free()
#	print (test_move(transform, velocity))
#	move_and_collide(velocity)
#
#
#func leftShot():
#	velocity.x = -50
#
#func rightShot():
#	velocity.x = 50

extends Area2D

var side = 0

func _ready():
	pass
	
func _process(delta):
	if(position.y >= 1000):
		queue_free()
	if(side == 1):
		position.x -= 1
	if(side == 2):
		position.x += 1
	position.y += 8
	
	
func leftShot():
	side = 1
	
func rightShot():
	side = 2
	
func _on_Projectile_area_entered(area):
	queue_free()

func _on_EnemyProjectile_body_entered(body):
	Global.lives -= 1
	queue_free()

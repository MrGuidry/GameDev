extends KinematicBody2D

var velocity = Vector2()


func _ready():
	velocity.y = -400

func _process(delta):
	if(position.y < -700):
		queue_free()
	move_and_slide(velocity)

func leftShot():
	velocity.x = -50

func rightShot():
	velocity.x = 50

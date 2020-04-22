extends KinematicBody2D

var speed = Vector2(0,0)
var movement = 400
var powerTriple = false

var projectile = preload("res://Projectile.tscn")

func _ready():
	pass


func _process(delta):
	get_input()
	move_and_slide(speed)
	
func get_input():
	speed = Vector2.ZERO
	if Input.is_key_pressed(KEY_LEFT):
		if(position.x > -264):
			speed.x = -movement
	if Input.is_key_pressed(KEY_RIGHT):
		if(position.x < 270):
			speed.x = movement
	if Input.is_action_just_pressed("Spacebar") && get_tree().get_nodes_in_group("Enemy").size() != 0:
		if(!powerTriple && get_tree().get_nodes_in_group("Bullets").size() < 4):
			$ShotSound.play()
			shoot()
		elif(powerTriple && get_tree().get_nodes_in_group("Bullets").size() < 12):
			$ShotSound.play()
			shoot()
	if Input.is_action_just_pressed("TripleShot"):
		powerTriple = !powerTriple
	
func shoot():
	if(powerTriple):
		var bullet = projectile.instance()
		var bullet2 = projectile.instance()
		var bullet3 = projectile.instance()
		
		bullet.position = get_position()
		bullet2.position = get_position()
		bullet3.position = get_position()
		
		bullet.position.y -= 60
		bullet2.position.y -= 60
		bullet3.position.y -= 60
		
		bullet2.position.x += 50
		bullet2.rightShot()
		
		bullet3.position.x -= 50
		bullet3.leftShot()
		
		get_parent().add_child(bullet)
		get_parent().add_child(bullet2)
		get_parent().add_child(bullet3)
	else:
		var bullet = projectile.instance()
		bullet.position = get_position()
		bullet.position.y -= 60
		get_parent().add_child(bullet)
		


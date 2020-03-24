extends KinematicBody2D

var speed = Vector2(0,0)
var movement = 400
var powerTriple = true

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
	if Input.is_action_just_pressed("Spacebar"):
		if(!powerTriple && get_tree().get_nodes_in_group("Bullets").size() < 4):
			shoot()
		elif(powerTriple && get_tree().get_nodes_in_group("Bullets").size() < 12):
			shoot()
	
func shoot():
	if(powerTriple):
		var bullet1 = projectile.instance()
		var bullet2 = projectile.instance()
		var bullet3 = projectile.instance()
		
		bullet1.position = get_position()
		bullet2.position = get_position()
		bullet3.position = get_position()
	
		bullet1.position.y -= 45
		bullet2.position.y -= 45
		bullet3.position.y -= 45
		
		
		bullet1.position.x -= 50
		bullet1.leftShot()
		
		bullet3.position.x += 50
		bullet3.rightShot()
		
		get_parent().add_child(bullet1)
		get_parent().add_child(bullet2)
		get_parent().add_child(bullet3)
	else:
		var bullet = projectile.instance()
		bullet.position = get_position()
		bullet.position.y -= 45
		get_parent().add_child(bullet)

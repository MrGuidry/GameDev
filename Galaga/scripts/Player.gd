extends KinematicBody2D

signal grab_powerup

var speed = Vector2(0,0)
var movement = 400

var projectile = preload("res://Projectile.tscn")

func _ready():
	pass

func _process(delta):
	get_input()
	_change_sprite()
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
		if(!Global.powerTriple && get_tree().get_nodes_in_group("Bullets").size() < 4):
			$ShotSound.play()
			shoot()
		elif(Global.powerTriple && get_tree().get_nodes_in_group("Bullets").size() < 6):
			$TripleShotSound.play()
			shoot()
	
func shoot():
	if(Global.powerTriple):
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
		
var starPower = preload("res://sprites/krakatoaStar.png")
var regular = preload("res://sprites/krakatoa.png")
var triplePower = preload("res://sprites/krakatoaTriple.png")
func _change_sprite():
	if(Global.powerInvincible):
		get_node("Sprite").set_texture(starPower)
	elif(Global.powerTriple):
		get_node("Sprite").set_texture(triplePower)
	else:
		get_node("Sprite").set_texture(regular)

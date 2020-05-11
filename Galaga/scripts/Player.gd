extends KinematicBody2D

# ---------------------------------------
# Description:
# Everything (methods/creation/attributes/controls) 
# associated to the player
#
# Also Pertains to: Projectiles
# Also Pertains to: Powerups
#-----------------------------------------

# CONSTANT ATTRIBUTES:
const MAX_BULLET_AMOUNT = 4 # maximum amount of projectiles on screen without powerup
const MAX_TRIPLE_BULLET_AMOUNT = 6 # maximum amount of projectiles on screen with triple shot 
const MOVEMENT = 400 # How much the player moves

# Loaded resources: 
var projectile = preload("res://projectile.tscn") # Visual sprite for projectiles

var REGULAR = preload("res://sprites/krakatoa.png") # No powerup
var STARPOWER = preload("res://sprites/krakatoaStar.png") # 'I' powerup sprite
var TRIPLEPOWER = preload("res://sprites/krakatoaTriple.png") # 'T' powerup sprite

# Attributes:
var speed = Vector2(0,0)

#-----------------------------------------------------------------------
# Initialization Methods

func _ready():
	pass # NO ON_READY ACTIONS NEEDED

#------------------------------------------------------------------------
# Process Methods: Input and constant time processes

# All player actions are dealt with:
func _process(delta):
	get_input()
	_change_sprite()
	move_and_slide(speed)

# Changes the sprite for the player depending on the powerup being used.
func _change_sprite(): 
	if(Global.powerInvincible):
		get_node("Sprite").set_texture(STARPOWER)
	elif(Global.powerTriple):
		get_node("Sprite").set_texture(TRIPLEPOWER)
	else:
		get_node("Sprite").set_texture(REGULAR)

# User Keyboard input
# CONTROLS:
# LEFT KEY: move left
# RIGHT KEY: move right
# SPACE BAR: shoot	
func get_input():
	speed = Vector2.ZERO
	if Input.is_key_pressed(KEY_LEFT):
		if(position.x > -264):
			speed.x = -MOVEMENT
	if Input.is_key_pressed(KEY_RIGHT):
		if(position.x < 270):
			speed.x = MOVEMENT
	if Input.is_action_just_pressed("Spacebar") && get_tree().get_nodes_in_group("Enemy").size() != 0:
		if(!Global.powerTriple && get_tree().get_nodes_in_group("Bullets").size() < MAX_BULLET_AMOUNT):
			$ShotSound.play()
			shoot()
		elif(Global.powerTriple && get_tree().get_nodes_in_group("Bullets").size() < MAX_TRIPLE_BULLET_AMOUNT):
			$TripleShotSound.play()
			shoot()
	
func shoot():
	if(Global.powerTriple): # When shooting 3 shots (triple shot powerup)
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
	else:  # regular shot
		var bullet = projectile.instance()
		bullet.position = get_position()
		bullet.position.y -= 60
		get_parent().add_child(bullet)
		
#-------------------------------------------------------------------


extends Node2D

# ---------------------------------------
# Description:
# Methods/Attributes pertaining to the 
# creation/actions of enemies.
#
# Also Pertains to: Enemy Projectiles
# Also Pertains to: Powerups
#-----------------------------------------

# CONST ATTRIBUTES:
const POWERUP_SPAWN_CHANCE = 10 # Chance for a powerup to spawn

# Used for Twen
onready var movement = get_node("movement") # Back and forth movement

# Signals 
signal enemy_killed # upon the enemy (this) is killed

# Visuals used for enemies.
var projectile = preload("res://enemyProjectile.tscn")
var purpleProjectile = preload("res://enemyBigProjectile.tscn")
var powerup = preload("res://powerup.tscn")

# Attributes associated to enemies
var health
var speed
var damage
var reward

#------------------------------------------------------------------
# Initialization methods of an Enemy/Enemies

func _ready():
	_init_tween() # Used for movement

# Movement back and forth motion using the vector positions
func _init_tween():
	movement.interpolate_property(self, 'position', get_position(), Vector2(position.x+75,position.y),3,Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	movement.interpolate_property(self, 'position', Vector2(position.x+75,position.y), get_position(),3,Tween.TRANS_SINE, Tween.EASE_IN_OUT,3)
	movement.start()

# Initializes the type of enemy based on the passed in color	
func set_attributes(color):
	if(color=="Green"): 
		# Weakest enemy
		health = 1
		speed = 8
		damage = 5
		reward = 100
	elif(color == "Red"):
		# Boss enemy
		if(Global.variant):
			health = 10
		else:
			health = 6
		speed = 10
		damage = 5
		reward = 500
	else:
		# Mini Boss enemy
		if(Global.variant):
			health = 5
		else:
			health = 3
		speed = 0
		damage = 20
		reward = 250

# ------------------------------------------------------------
# Methods while Running: Enemy Projectiles and Shooting

func _process(delta):	
	shoot_interval() # How often an enemy shoots

func shoot_interval():
	if(speed == 0):  # Purple Shooting on a FIXED slow interval
		if((randi()%1000000+1)%1000 == 0):
			shoot()
	else: # Green/Red shoot on a dynamically progressed interval
		while(randi()%Global.multi+1 == 3):
			shoot()
			
			# Modify difficulty multiplier
			if(Global.multi >500):
				Global.multi -= 10
			elif(Global.multi > 250):
				Global.multi -= 5
			elif(Global.multi > 30):
				Global.multi -= 1

# Determines what kind of projectile to shoot and how many projectiles
func shoot():
	if(speed == 8): # Green enemy shoots 1 projectile
		var bullet = projectile.instance()
		bullet.position = get_position()
		bullet.position.y += 60
		bullet.set_fall_speed(speed)
		bullet.connect("player_hit",self, "_on_player_hit")
		get_parent().add_child(bullet)
	elif(speed == 10): # Red enemy shoots 3 progressive projectiles
		var bullet1 = projectile.instance()
		var bullet2 = projectile.instance()
		var bullet3 = projectile.instance()
		bullet1.position = get_position()
		bullet2.position = get_position()
		bullet3.position = get_position()
		bullet1.position.y += 60
		bullet2.position.y += 120
		bullet3.position.y += 180
		bullet1.set_fall_speed(speed)
		bullet2.set_fall_speed(speed)
		bullet3.set_fall_speed(speed)
		bullet1.connect("player_hit",self, "_on_player_hit")
		get_parent().add_child(bullet1)
		bullet2.connect("player_hit",self, "_on_player_hit")
		get_parent().add_child(bullet2)
		bullet3.connect("player_hit",self, "_on_player_hit")
		get_parent().add_child(bullet3)
	else: # Purple Projectile 
		var bullet = purpleProjectile.instance()
		bullet.position = get_position()
		bullet.position.y += 60
		bullet.connect("player_hit",self, "_on_player_hit")
		get_parent().add_child(bullet)

# IF a projectile hits a player:
func _on_player_hit():
	Global.lives -= damage
	$PlayerHitSound.play() #Sound Upon hitting a player

#----------------------------------------------------------------
# Methods while Running: Enemy Death:

func _on_Enemy_area_entered(area):
	if(health-1 <= 0):	# If health falls below 0
		# then destroy enemy
		Global.score += reward
		emit_signal("enemy_killed")
		
		# % Chance for a powerup to spawn upon death
		if(Global.variant && randi()%100+1 <= POWERUP_SPAWN_CHANCE):
			var power = powerup.instance()
			power.position = get_position()
			power.position.y += 60
			get_parent().call_deferred("add_child",power)
		queue_free() # Removes enemy
	else: # If health does not fall below 0
		# then only adjust health
		Global.score += 50
		$HurtSound.play() # sound upon enemy hit
		health -= 1
	
#-------------------------------------------------------------------

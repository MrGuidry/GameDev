extends Area2D

# ---------------------------------------
# Description:
# Methods/attributes pertaining to the 'green'
# and 'purple' enemy's small projectiles.
#-----------------------------------------

# Signals
signal player_hit # Upon a player hit

# Attributes associated to the projectile
var speed # Speed in which the projectile moves down the screen

func _ready():
	pass # NO ON_READY ACTIONS NEEDED

# INIT method for setting the speed of the projectile 
# ** MUST BE CALLED UPON INSTANCE MADE **
func set_fall_speed(s):
	speed = s

# While projectile exists it will move gradually down the screen
# at the pace of the attribute 'speed'	
func _process(delta):
	if(position.y >= 1000):
		queue_free()
	position.y += speed

# If two projectiles are on top of each other:	
func _on_Projectile_area_entered(area):
	queue_free() # Destroy projectile

# Enters the "players" body
func _on_EnemyProjectile_body_entered(body):
	# Can not injure the player if they are invincible
	if(!Global.powerInvincible):
		emit_signal("player_hit")
	queue_free()



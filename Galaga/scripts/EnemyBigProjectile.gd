extends Area2D

# ---------------------------------------
# Description:
# Methods/attributes pertaining to the 'purple'
# enemy's large projectiles.
#-----------------------------------------

# CONST ATTRIBUTES:
const FALL_SPEED = 6 # The speed in which the projectile moves down the screen. 

# Signals
signal player_hit # Upon a player hit

func _ready():
	pass # NO ON_READY ACTIONS NEEDED

# Gradually moves projectile down the screen.	
func _process(delta):
	if(position.y >= 1000):
		queue_free()
	position.y += FALL_SPEED

# If two projectiles are on top of each other:	
func _on_Projectile_area_entered(area):
	queue_free() # Destroy projectile

# Enters the "players" body
func _on_EnemyProjectile_body_entered(body):
	# Can not injure the player if they are invincible
	if(!Global.powerInvincible):
		emit_signal("player_hit")
	queue_free()


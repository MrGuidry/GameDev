extends Area2D

# ---------------------------------------
# Description:
# Methods/Attributes pertaining to the 
# PLAYER projectiles
#-----------------------------------------

# CONST ATTRIBUTES:
const RISE_SPEED = 8 # speed in which the projectile moves up the screen.

# Projectile Variable Attributes:
var side = 0

#----------------------------------------------------------------------	
# Initialization 

func _ready():
	pass # NO ON_READY ACTIONS NEEDED

# Initializes Direction of a shot 
# ** USED FOR TRIPLE SHOT ONLY **	
func leftShot():
	side = 1
	
func rightShot():
	side = 2
#-----------------------------------------------------------------------

# Movement of a projectile in a particular motion	
func _process(delta):
	if(position.y < -700):
		queue_free()
	if(side == 1):
		position.x -= 1
	if(side == 2):
		position.x += 1
	position.y -= RISE_SPEED


# Upon area entered (projectile/enemy)
func _on_Projectile_area_entered(area):
	queue_free() # destroy

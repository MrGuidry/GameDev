extends Area2D

# ---------------------------------------
# Description:
# Methods/Attributes pertaining to the 
# Special enemy wild card: Pufferfish
#-----------------------------------------

# CONSTANT ATTRIBUTES:
const FALL_SPEED = 2 # speed for which the pufferfish falls from the top of the screen
const DAMAGE = 30 # amount of damage done to a player by the pufferfish

# Signals:
signal on_pufferfish_hit # Once a player's body is hit

func _ready():
	pass # NO ON_READY ACTIONS NEEDED
	
func _process(delta):
	if(position.y >= 1000):
		queue_free()
	position.y += FALL_SPEED
	

func _on_pufferfish_body_entered(body):
	if(!Global.powerInvincible):
		Global.lives -= DAMAGE
	emit_signal("on_pufferfish_hit")
	queue_free()

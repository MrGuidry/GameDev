extends Area2D

# ---------------------------------------
# Description:
# Methods/Attributes pertaining to the 
# initialization and destruction of 
# powerups
#-----------------------------------------

# CONST ATTRIBUTES:
const HEALTH_GIVE_AMOUNT = 3 # ammount of health a type 'H' powerup gives
const TIME_FOR_TRIPLESHOT = 5 # time interval given for type 'T' powerup
const TIME_FOR_INVINCEABLE = 7 # time interval given for type 'I' powerup
const FALL_SPEED = 3 # Speed in which the powerup falls down vertically on the screen
const CHANCE_FOR_TRIPLE = 35 # chance for which the powerup type is 'I'
const CHANCE_FOR_INVINCABLE = 15 # chance for which the powerup type is 'T'

# on ready initial Variables
onready var type_label = get_node("type") # label that says what type of powerup 
onready var death = get_node("death") # Death Twen

# Attributes of a powerup.
var type

# Initialization of a powerup
func _ready():
	# Random value given for a chance of assigning the type of powerup
	var rando = randi()%100+1
	if(rando <= CHANCE_FOR_INVINCABLE):
		type = 'I' # Invincible powerup
	elif(rando <= CHANCE_FOR_TRIPLE):
		type = 'T' # Triple shot powerup
	else: # chance is 100-(CHANCE_FOR_TRIPLE + CHANCE_FOR_INVINCABLE)
		type = 'H' # health powerup
	type_label.set_text(type)
	
	# Init Twen for death
	death.interpolate_property(self, 'scale', get_scale(), Vector2(0, 0), 0.1, Tween.TRANS_QUAD, Tween.EASE_OUT)

# Gradually moves powerup down the screen.		
func _process(delta):
	if(position.y >= 1000):
		queue_free() # Destroy powerup if leaves screen
	position.y += FALL_SPEED
	
# Once the powerup reaches the player:	
func _on_powerup_body_entered(body):
	match type: #Switch the type
		'I': # Invincable
			if(Global.powerTriple):
				Global.powerTriple = false
			Global.powerInvincible = true
			Global.timer = TIME_FOR_TRIPLESHOT
			print("You got I")
		'T': # Triple Shot
			if(Global.powerInvincible):
				Global.powerInvincible = false 
			Global.powerTriple = true
			Global.timer = TIME_FOR_INVINCEABLE
			print("You got T")
		'H': # Health
			if(Global.lives+HEALTH_GIVE_AMOUNT >= 100):
				Global.lives=100
			else:
				Global.lives += HEALTH_GIVE_AMOUNT
	$PowerupSound.play()
	death.start()
	yield ($PowerupSound, "finished")
	queue_free() # Destroy powerup

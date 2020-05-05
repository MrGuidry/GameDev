extends Area2D

var type
onready var type_label = get_node("type")

func _ready():
	var rando = randi()%100+1
	if(rando <= 15):
		type = 'I'
	elif(rando <= 35):
		type = 'T'
	else:
		type = 'H'
	type_label.set_text(type)
	
func _process(delta):
	if(position.y >= 1000):
		queue_free()
	position.y += 3
	

func _on_powerup_body_entered(body):
	match type:
		'I': 
			if(Global.powerTriple):
				Global.powerTriple = false
			Global.powerInvincible = true
			Global.timer = 5
			print("You got I")
		'T':
			if(Global.powerInvincible):
				Global.powerInvincible = false 
			Global.powerTriple = true
			Global.timer = 7
			print("You got T")
		'H': 
			if(Global.lives+5 >= 100):
				Global.lives=100
			else:
				Global.lives += 5
	queue_free()

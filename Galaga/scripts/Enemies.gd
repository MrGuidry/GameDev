extends Node2D

onready var movement = get_node("movement")
onready var death = get_node("death")
signal enemy_killed
signal enemy_hit

var projectile = preload("res://EnemyProjectile.tscn")
var purpleProjectile = preload("res://EnemyBigProjectile.tscn")
var powerup = preload("res://powerup.tscn")

var health
var speed
var damage
var reward

func _ready():
	_init_tween()
	death.interpolate_property(self, 'scale', get_scale(), Vector2(0, 0), 0.1, Tween.TRANS_QUAD, Tween.EASE_OUT)
	
func set_attributes(color):
	if(color=="Green"):
		health = 1
		speed = 8
		damage = 5
		reward = 100
	elif(color == "Red"):
		if(Global.variant):
			health = 10
		else:
			health = 6
		speed = 10
		damage = 5
		reward = 500
	else:
		if(Global.variant):
			health = 5
		else:
			health = 3
		speed = 0
		damage = 20
		reward = 250


func _init_tween():
	movement.interpolate_property(self, 'position', get_position(), Vector2(position.x+75,position.y),3,Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	movement.interpolate_property(self, 'position', Vector2(position.x+75,position.y), get_position(),3,Tween.TRANS_SINE, Tween.EASE_IN_OUT,3)
	movement.start()


func _on_Enemy_area_entered(area):
	if(health-1 <= 0):	
		Global.score += reward
		emit_signal("enemy_killed")
		if(Global.variant && randi()%100+1 <= 10):
			var power = powerup.instance()
			power.position = get_position()
			power.position.y += 60
			
			get_parent().add_child(power)
		death.start()
		queue_free()
	else:
		Global.score += 50
		$HurtSound.play()
		health -= 1

func _process(delta):	
	shoot_interval()
	

func shoot_interval():
	if(speed == 0):
		if((randi()%1000000+1)%1000 == 0):
			shoot()
	else:
		while(randi()%Global.multi+1 == 3 && Global.respawned):
			shoot()
			if(Global.multi >500):
				Global.multi -= 10
			elif(Global.multi > 250):
				Global.multi -= 5
			elif(Global.multi > 30):
				Global.multi -= 1
func shoot():
	if(speed == 8):
		var bullet = projectile.instance()
		bullet.position = get_position()
		bullet.position.y += 60
		bullet.set_fall_speed(speed)
		bullet.connect("player_hit",self, "_on_player_hit")
		get_parent().add_child(bullet)
	elif(speed == 10):
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
	else:
		var bullet = purpleProjectile.instance()
		bullet.position = get_position()
		bullet.position.y += 60
		bullet.connect("player_hit",self, "_on_player_hit")
		get_parent().add_child(bullet)
	

func _on_player_hit():
	Global.lives -= damage
	$PlayerHitSound.play()

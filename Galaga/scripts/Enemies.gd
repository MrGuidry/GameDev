extends Node2D

onready var movement = get_node("movement")
onready var death = get_node("death")
signal enemy_killed

var projectile = preload("res://EnemyProjectile.tscn")
var powerup = preload("res://powerup.tscn")

func _ready():
	_init_tween()
	death.interpolate_property(self, 'scale', get_scale(), Vector2(0, 0), 0.1, Tween.TRANS_QUAD, Tween.EASE_OUT)
	

func _init_tween():
	movement.interpolate_property(self, 'position', get_position(), Vector2(position.x+75,position.y),3,Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	movement.interpolate_property(self, 'position', Vector2(position.x+75,position.y), get_position(),3,Tween.TRANS_SINE, Tween.EASE_IN_OUT,3)
	movement.start()


func _on_Enemy_area_entered(area):
	emit_signal("enemy_killed")
	if(Global.variant && randi()%100+1 <= 10):
		var power = powerup.instance()
		power.position = get_position()
		power.position.y += 60
		get_parent().add_child(power)
	death.start()
	queue_free()

func _process(delta):	
	shoot_interval()
	

func shoot():
	var bullet = projectile.instance()
	bullet.position = get_position()
	bullet.position.y += 60
	get_parent().add_child(bullet)

func shoot_interval():
	while(randi()%Global.multi+1 == 3 && Global.respawned):
		shoot()
		if(Global.multi >500):
			Global.multi -= 10
		elif(Global.multi > 250):
			Global.multi -= 5
		elif(Global.multi > 30):
			Global.multi -= 1

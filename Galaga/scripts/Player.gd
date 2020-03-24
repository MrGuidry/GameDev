extends KinematicBody2D

var speed = Vector2(0,0)
var movement = 400

var projectile = preload("res://Projectile.tscn")

func _ready():
	pass


func _process(delta):
	get_input()
	move_and_slide(speed)
	
func get_input():
	speed = Vector2.ZERO
	if Input.is_key_pressed(KEY_LEFT):
		if(position.x > -264):
			speed.x = -movement
	if Input.is_key_pressed(KEY_RIGHT):
		if(position.x < 270):
			speed.x = movement
	if Input.is_action_just_pressed("Spacebar"):
		if(get_tree().get_nodes_in_group("Bullets").size() < 4):
			shoot()
	
func shoot():
	var bullet = projectile.instance()
	bullet.position = get_position()
	bullet.position.y -= 45
	get_parent().add_child(bullet)

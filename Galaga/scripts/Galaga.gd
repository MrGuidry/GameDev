extends Node2D

onready var enemy = preload("res://Enemy.tscn")
onready var enemies = get_node("Enemies")

var screensize
var score = 0

func _ready():
	randomize()
	screensize = get_viewport().get_visible_rect().size
	set_process(true)
	spawn_enemies(24)

func _process(delta):
	if enemies.get_child_count() == 0:
		spawn_enemies(24)

func spawn_enemies(num):
	for i in num:
		var e = enemy.instance()
		if(i < 8):
			e.set_position(Vector2(100+(i*50),100))
		else:
			if i < 16:
				e.set_position(Vector2(100+((i-8)*50),150))
			else:
				e.set_position(Vector2(100+((i-16)*50),200))
		enemies.add_child(e)

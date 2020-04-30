extends Node2D

onready var enemy = preload("res://Enemy.tscn")
onready var enemies = get_node("Enemies")
onready var score_label = get_node("hud/score_label")
onready var life_label = get_node("hud/life_label")


var screensize


func _ready():
	randomize()
	screensize = get_viewport().get_visible_rect().size
	set_process(true)
	spawn_enemies(21)

func _process(delta):
	if(Global.lives != 0 ):
		var livesString = "Lives: " + (str(Global.lives))
		life_label.set_text(livesString)
	else:
		get_tree().change_scene("res://gameOver.tscn")
		
		
		
	if enemies.get_child_count() == 0 && get_tree().get_nodes_in_group("Bullets").size() == 0:
		spawn_enemies(21)
		

func spawn_enemies(num):
	for i in num:
		var e = enemy.instance()
		if(i < 7):
			e.set_position(Vector2(37+(i*75),75))
		else:
			if i < 14:
				e.set_position(Vector2(37+((i-7)*75),150))
			else:
				e.set_position(Vector2(37+((i-14)*75),225))
		e.connect("enemy_killed",self, "_on_enemy_killed")		
		enemies.add_child(e)

func _on_enemy_killed():
	Global.score += 15
	var scoreStr =  "Score: " + (str(Global.score))	
	score_label.set_text(scoreStr)
	$HitSound.play()


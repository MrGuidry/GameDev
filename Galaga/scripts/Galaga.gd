extends Node2D

onready var enemy = preload("res://Enemy.tscn")
onready var enemies = get_node("Enemies")
onready var pufferfish = preload("res://pufferfish.tscn")
onready var score_label = get_node("hud/score_label")
onready var life_label = get_node("hud/life_label")
onready var stage_label = get_node("hud/stage_label")

var screensize
var stage

func _ready():
	randomize()
	screensize = get_viewport().get_visible_rect().size
	set_process(true)
	spawn_enemies(21)
	stage = 1
	print(stage)

func _process(delta):
	if(randi()%5000+1 <= 2):
		var p = pufferfish.instance()
		p.position.x = randi()%535+35
		p.position.y = -20
		p.connect("on_Hit", self, "_on_puffer_hit")
		add_child(p)
	if(Global.lives > 0 ):
		var livesString = "Health: " + (str(Global.lives))
		life_label.set_text(livesString)
	else:
		get_tree().change_scene("res://gameOver.tscn")
		
	if get_tree().get_nodes_in_group("Enemy").size()  == 0 && get_tree().get_nodes_in_group("Bullets").size() == 0:
		stage+=1
		var stageString = "Stage " + (str(stage))
		stage_label.set_text(stageString)
		if(stage <= 3):
			spawn_enemies(21)
		elif(stage <= 6):
			if((randi()%100+1) <= 40):
				spawn_enemies(14)
			else:
				spawn_enemies(21)
		else:
			var r = randi()%100+1
			if(r <= 25):
				spawn_enemies(13)
			elif( r <= 55):
				spawn_enemies(14)
			else:
				spawn_enemies(21)
		
	if(Global.timer > 0):
		Global.timer -= delta
		if(Global.timer <= 0):
			Global.powerTriple = false
			Global.powerInvincible = false

var enemyPurple = preload("res://sprites/Enemy1.png")
var enemyRed = preload("res://sprites/Enemy2.png")
var enemyGreen = preload("res://sprites/Enemy3.png")

func spawn_enemies(num):
	if(num == 14):
		on_wave_2(num)
	elif(num == 21):
		on_wave_1(num)
	else:
		on_wave_3(num)

func on_wave_1(num):
	for i in num:
		var e = enemy.instance()
		e.get_node("Sprite").set_texture(enemyGreen)
		e.set_attributes("Green")
		if(i < 7):
			e.set_position(Vector2(37+(i*75),75))
		else:
			if i < 14:
				e.set_position(Vector2(37+((i-7)*75),150))
			else:
				e.set_position(Vector2(37+((i-14)*75),225))
		e.connect("enemy_killed",self, "_on_enemy_killed")		
		enemies.add_child(e)

func on_wave_2(num):
	for i in num:
		var e = enemy.instance()
		if(i >= 7 ):
			e.get_node("Sprite").set_texture(enemyGreen)
			e.set_attributes("Green")
			e.set_position(Vector2(30+((i-7)*77),250))
		elif(i < 7 && i >2):
			if(i == 3 || i == 6):
				e.get_node("Sprite").set_texture(enemyGreen)
				e.set_attributes("Green")
			else:
				e.get_node("Sprite").set_texture(enemyPurple)
				e.set_attributes("Purple")
			e.set_position(Vector2(29+(i-3)*155,160))
		else:
			if(i == 1):
				e.get_node("Sprite").set_texture(enemyRed)
				e.set_attributes("Red")
			else:
				e.get_node("Sprite").set_texture(enemyPurple)
				e.set_attributes("Purple")
			e.set_position(Vector2(65+(i*200),75))	
		e.connect("enemy_killed",self, "_on_enemy_killed")		
		enemies.add_child(e)
		
func on_wave_3(num):
	for i in num:
		var e = enemy.instance()
		if(i<=2):
			e.get_node("Sprite").set_texture(enemyRed)
			e.set_attributes("Red")
			e.set_position(Vector2(65+(i*200),75))
		elif(i<=5):
			if(i == 4):
				e.get_node("Sprite").set_texture(enemyGreen)
				e.set_attributes("Green")
			else:
				e.get_node("Sprite").set_texture(enemyPurple)
				e.set_attributes("Purple")
			e.set_position(Vector2(34+((i-3)*225),160))
		elif(i<=7):
			e.get_node("Sprite").set_texture(enemyPurple)
			e.set_attributes("Purple")
			e.set_position(Vector2(190+((i-6)*140),225))
		else:
			if(i == 10):
				e.get_node("Sprite").set_texture(enemyPurple)
				e.set_attributes("Purple")
			else:
				e.get_node("Sprite").set_texture(enemyGreen)
				e.set_attributes("Green")
			e.set_position(Vector2(35+((i-8)*110),310))
		e.connect("enemy_killed",self, "_on_enemy_killed")		
		enemies.add_child(e)
	
			
func _on_enemy_killed():
	var scoreStr =  "Score: " + (str(Global.score))	
	score_label.set_text(scoreStr)
	$HitSound.play()
	
func _on_puffer_hit():
	$PufferPopSound.play()


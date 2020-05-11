extends Node2D

#---------------------------------------------
# 		GALAGA CLONE
#---------------------------------------------

# ---------------------------------------
# Description:
# Methods/Attributes pertaining to the
# entirety of the game with the
# handling of both player and enemies
#
# Also Pertains to: Enemies
# Also Pertains to: Players
# Also Pertains to: Labels
#-----------------------------------------

# CONSTANT ATTRIBUTES:
const PUFFERFISH_SPAWN_CHANCE = 2 # ** Out of 1-5000 ** chance to spawn a pufferfish
const STAGE_DIFFICULTY_CHANGE_1 = 3 # initial number of stages to pass until harder difficulty introduced
const STAGE_DIFFICULTY_CHANGE_2 = 6 # proceeding number of stages to pass until harder difficulty introduced

	# ** DO NOT CHANGE THE FOLLOWING CONSTANTS **
const STAGE_TYPE_GREEN_ARMY = 21  #number indicating the stage with all green enemies
const STAGE_TYPE_MINI_BOSS = 14 # number indicating the stage with some green enemies and one red enemy
const STAGE_TYPE_ULTIMATE_BOSS = 13 # number indicating the stage with three red enemies

# Preloaded Resources:
onready var enemy = preload("res://enemy.tscn")
onready var pufferfish = preload("res://pufferfish.tscn")
	# Sprites of the types of enemies:
var enemyPurple = preload("res://sprites/Enemy1.png")
var enemyRed = preload("res://sprites/Enemy2.png")
var enemyGreen = preload("res://sprites/Enemy3.png")

# Nodes for labels:
onready var enemies = get_node("Enemies")
onready var score_label = get_node("hud/score_label")
onready var life_label = get_node("hud/life_label")
onready var stage_label = get_node("hud/stage_label")

# Attributes:
var screensize
var stage

#----------------------------------------------------------------------
# Initialization Methods:

func _ready():
	randomize()
	screensize = get_viewport().get_visible_rect().size
	set_process(true)
	spawn_enemies(STAGE_TYPE_GREEN_ARMY)
	stage = 1 # first stage
	
#-----------------------------------------------------------------------
# Process Methods: What runs during the game

func _process(delta):
	# Game management: Health and Game over
	if(Global.lives > 0 ):
		var livesString = "Health: " + (str(Global.lives))
		life_label.set_text(livesString)
	else:
		get_tree().change_scene("res://gameOver.tscn")
		
	# Game Event: Pufferfish Spawn
	if(randi()%5000+1 <= PUFFERFISH_SPAWN_CHANCE):
		spawn_pufferfish()
	
	# Game Event: Powerup Timer
	if(Global.timer > 0):
		Global.timer -= delta
		if(Global.timer <= 0):
			Global.powerTriple = false
			Global.powerInvincible = false
			
	# Game Event: Upon all enemy on screen destroyed:	
	if get_tree().get_nodes_in_group("Enemy").size()  == 0 && get_tree().get_nodes_in_group("Bullets").size() == 0:
		# Update Stage Label/Stage
		update_stage()
		
		# Spawn Enemy Stage type:
		if(stage <= STAGE_DIFFICULTY_CHANGE_1):
			spawn_enemies(STAGE_TYPE_GREEN_ARMY)
		elif(stage <= STAGE_DIFFICULTY_CHANGE_2):
			# Introduce chance to spawn stage type 2
			if((randi()%100+1) <= 40):
				spawn_enemies(STAGE_TYPE_MINI_BOSS)
			else:
				spawn_enemies(STAGE_TYPE_GREEN_ARMY)
		else:
			# Introduce chance to spawn stage type 3
			var r = randi()%100+1
			if(r <= 25):
				spawn_enemies(STAGE_TYPE_ULTIMATE_BOSS)
			elif( r <= 55):
				spawn_enemies(STAGE_TYPE_MINI_BOSS)
			else:
				spawn_enemies(STAGE_TYPE_GREEN_ARMY)
		
# spawns a pufferfish ABOVE the screen
func spawn_pufferfish():
	var p = pufferfish.instance()
	p.position.x = randi()%535+35
	p.position.y = -20
	p.connect("on_pufferfish_hit", self, "_on_puffer_hit")
	add_child(p)

# Updates the stage label
func update_stage():
	stage+=1
	var stageString = "Stage " + (str(stage))
	stage_label.set_text(stageString)

#-------------------------------------------------------------------
# Enemy Spawn Handling
func spawn_enemies(num):
	if(num == STAGE_TYPE_MINI_BOSS):
		on_wave_2(num)
	elif(num == STAGE_TYPE_GREEN_ARMY):
		on_wave_1(num)
	else:
		on_wave_3(num)

# SETUP: Spawn in formation for STAGE_TYPE_GREEN_ARMY
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

# SETUP: Spawn in formation for STAGE_TYPE_MINI_BOSS
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

# SETUP: Spawn in formation for STAGE_TYPE_ULTIMATE_BOSS		
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
#----------------------------------------------------------------------
# Event Actions: Enemy/Player Interaction consequences and sound	

# When an enemy is killed:
func _on_enemy_killed():
	# Update Score:
	var scoreStr =  "Score: " + (str(Global.score))	
	score_label.set_text(scoreStr)
	
	$HitSound.play()

# When a pufferfish enters player body:	
func _on_puffer_hit():
	$PufferPopSound.play()

#-----------------------------------------------------------------------

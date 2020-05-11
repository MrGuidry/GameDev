extends Node

# ---------------------------------------
# Description:
# GLOBAL Variables for use throughout the
# game. 
#-----------------------------------------

# Difficulty Modifer Variables
var multi = 1001

# Labels relevant to the player variables
var lives = 100
var score = 0

# Game Style Variables
var variant = false
var powerTriple = false
var powerHeal = false
var powerInvincible = false
var timer = 0

#-------------------------------------------------------------------------
# UNUSED METHODS/ATTRIBUTES:
var current_scene = null

# Called when the node enters the scene tree for the first time.
func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)

func goto_scene(path):
	call_deferred("_deferred_goto_scene", path)
	
func _deferred_goto_scene(path):
	# It is now safe to remove the current scene
	current_scene.free()

	# Load the new scene.
	var s = ResourceLoader.load(path)

	# Instance the new scene.
	current_scene = s.instance()

	# Add it to the active scene, as child of root.
	get_tree().get_root().add_child(current_scene)

	# Optionally, to make it compatible with the SceneTree.change_scene() API.
	get_tree().set_current_scene(current_scene)	
#-------------------------------------------------------------------------

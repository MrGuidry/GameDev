extends ParallaxLayer

# Called when the node enters the scene tree for the first time.
func _ready():
	motion_mirroring = get_child(0).texture.get_size().rotated(get_child(0).global_rotation)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.y = position.y +200*delta
	if(position.y > 800):
		position.y = 0

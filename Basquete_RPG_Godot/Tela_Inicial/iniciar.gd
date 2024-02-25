extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	size = Vector2(200, 50)
	flat = true
	var root_scene = get_tree().get_root()
	var button_position = Vector2(
		(root_scene.size.x - size.x) / 2,
		(root_scene.size.y - size.y) / 1.2
	)
	position = button_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

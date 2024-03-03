extends TextureButton

# Called when the node enters the scene tree for the first time.
func _ready():
	size = Vector2(250, 75)
	var root_scene = get_tree().get_root()
	var button_position = Vector2(
		(root_scene.size.x - size.x) / 2,
		(root_scene.size.y - size.y) / 1.135
	)
	position = button_position

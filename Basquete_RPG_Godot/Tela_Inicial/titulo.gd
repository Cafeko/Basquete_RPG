extends TextureRect


# Called when the node enters the scene tree for the first time.
func _ready():
	var root_scene = get_tree().get_root()
	var title_position = Vector2(
		(root_scene.size.x - size.x) / 2,
		(root_scene.size.y - size.y) / 8
	)
	position = title_position

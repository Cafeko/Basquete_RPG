# -<controlador_aparencia>------------------------------------------------------------------------ #
# Controla o visual (animações, contorno e etc) do objeto. 
# ------------------------------------------------------------------------------------------------ #
extends Node2D
class_name Aparencia

@export var pai : Node
@export var sprite : Sprite2D
@export var animacao : AnimationPlayer


func _ready():
	tira_contorno()

func set_visivel(valor : bool):
	pai.visible = valor

func bota_contorno(cor : Color):
	sprite.material.set("shader_parameter/line_color", cor)

func tira_contorno():
	sprite.material.set("shader_parameter/line_color", Color(1, 1, 1, 0))

func toca_animacao(animacao_nome : String):
	animacao.play(animacao_nome)

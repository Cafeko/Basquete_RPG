extends Node

@export var animacao : Sprite2D

func _ready():
	tira_contorno()

func bota_contorno(cor : Color):
	animacao.material.set("shader_parameter/line_color", cor)

func tira_contorno():
	animacao.material.set("shader_parameter/line_color", Color(1, 1, 1, 0))

# -<visual>--------------------------------------------------------------------------------------- #
# Cria e exibe elementos visuais.
# ------------------------------------------------------------------------------------------------ #
extends Node2D

@onready var linha = $Linha

func _ready():
	Global.visual = self

# Desenha o caminho especificado.
func linha_desenhar_caminho(caminho : Array[Vector2i]):
	linha.clear_points()
	for t in caminho:
		var cord = Global.quadra.tile_para_cord(t)
		linha.add_point(cord)

# Limpa o desenho feito com a linha.
func limpar_linha():
	linha.clear_points()

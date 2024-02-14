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

# "Pinta" a layer "Area" da quadra, nos tiles especificados.
func desenha_area(tiles : Array[Vector2i], cor_area : Color = Color("0000ff5a")):
	for t in tiles:
		Global.quadra.set_tile_area(t)
	Global.quadra.set_area_cor(cor_area)
	Global.quadra.set_area_contorno(tiles)

# Limpa a layer "Area" da quadra.
func limpa_area():
	Global.quadra.limpa_area()
	Global.quadra.limpa_contorno()

# -<quadra>--------------------------------------------------------------------------------------- #
# Contem o cenario da quadra e o AStarGrid2d que serve para a navegação dos personagens.
# Usado para pegar cordenadas no cenario e para usar/controlar a navegação.
# ------------------------------------------------------------------------------------------------ #
extends Node2D
class_name Quadra

@onready var tilemap : TileMap = $TileMap
@onready var formacoes_node = $Formacoes

var layers_id : Dictionary = {}
var formacoes_dict : Dictionary = {}
var tile_centro : Vector2i = Vector2i(8,4)
var tile_esq_centro : Vector2i = Vector2i(0, 4)
var tile_dir_centro : Vector2i = Vector2i(16, 4)
#var astar_grid : AStarGrid2D

func _ready():
	Global.quadra = self
	set_layers_id_dict()
	#cria_astar_grid()
	prepara_navegacao()
	prepara_formacoes()

# Coloca os IDs das layers do tilemap em um dicionario, para poderem ser acessado pelo seu nome.
func set_layers_id_dict():
	for l in tilemap.get_layers_count():
		var nome = tilemap.get_layer_name(l)
		layers_id[nome] = l

## Cria o AStarGrid2D.
#func cria_astar_grid():
	#astar_grid = AStarGrid2D.new()
	#astar_grid.region = tilemap.get_used_rect()
	#astar_grid.cell_size = tilemap.tile_set.tile_size
	#astar_grid.diagonal_mode = astar_grid.DIAGONAL_MODE_NEVER
	#astar_grid.update()
#
## Atualiza a navegação em um tile;
## Se o tile estiver vazio na layer "Navegação" ele é considerado não navegavel.
#func atualiza_navegacao_tile(tile : Vector2i):
	#var tile_data = tilemap.get_cell_tile_data(layers_id["Navegacao"], tile)
	#astar_grid.set_point_solid(tile, (tile_data == null))

# Cria a navegaçãocom base nos tiles no tilemap.
func prepara_navegacao():
	# Pega as informações do tilemap.
	var pos_inicial = tilemap.get_used_rect().position
	var tamanho = tilemap.get_used_rect().size
	# Percorre todos os tiles no tilemap.
	for x in tamanho.x:
		for y in tamanho.y:
			var tile = Vector2i(x + pos_inicial.x, y + pos_inicial.y)
			# Pega os dados dos tiles na layer "Chao".
			var tile_data = tilemap.get_cell_tile_data(layers_id["Chao"], tile)
			# Se tiver um tile na layer "Chao" ele é considerado navegavel. 
			if tile_data != null:
				set_tile_navegavel(tile)
			# Se não tiver um tile na layer "Chao" (tile_data == null) ele é considerado não navegavel.
			else:
				set_tile_nao_navegavel(tile)

# Coloca um tile na layer "Navegacao" o transformando em um tile navegavel.
func set_tile_navegavel(tile : Vector2i):
	tilemap.set_cell(layers_id["Navegacao"], tile, 2, Vector2i(0, 0))
	#atualiza_navegacao_tile(tile)

# Remove um tile na layer "Navegacao" o transformando em um tile não navegavel.
func set_tile_nao_navegavel(tile : Vector2i):
	tilemap.erase_cell(layers_id["Navegacao"], tile)
	#atualiza_navegacao_tile(tile)

# Guarda as formações no dicionario "formacoes_dict", para poderem ser acessado pelo seu nome.
func prepara_formacoes():
	for formacao in formacoes_node.get_children():
		var nome = formacao.name
		formacoes_dict[nome] = formacao

# Retorna a formação de acordo com seu nome.
func get_formacao(nome : String):
	return formacoes_dict[nome]

# Transforma as cordenadas do tilemap em uma cordenada global.
func tile_para_cord(tile : Vector2i):
	return tilemap.map_to_local(tile)

# Transforma uma cordenada global na cordenada de um tile no tilemap.
func cord_para_tile(cord : Vector2):
	return tilemap.local_to_map(cord)

# Pega uma cordenada global e retorna uma cordenada centrlizada no tile em que ela está.
func cordenada_centralizada(cord : Vector2):
	var tile = cord_para_tile(cord)
	return tile_para_cord(tile)

# Retorna se o tile é navegavel ou não.
func tile_navegavel(tile : Vector2i):
	var tile_data = tilemap.get_cell_tile_data(layers_id["Navegacao"], tile)
	return tile_data != null

# Retorna se o tile está dentro do chao da quadra ou não.
func tile_em_quadra(tile : Vector2i):
	var tile_data = tilemap.get_cell_tile_data(layers_id["Chao"], tile)
	return tile_data != null

# Retorna se o tile está dentro garrafão ou não.
func tile_em_garrafao(tile : Vector2i):
	var tile_data = tilemap.get_cell_tile_data(layers_id["Garrafao"], tile)
	return tile_data != null

func get_centro_cord():
	return tile_para_cord(tile_centro)

func get_esq_centro_cord():
	return tile_para_cord(tile_esq_centro)

func get_dir_centro_cord():
	return tile_para_cord(tile_dir_centro)

## Cria o caminho de tiles a ser percorido para ir de uma cordenada a outra.
#func cria_caminho(de : Vector2, para : Vector2):
	#var inicio = cord_para_tile(de)
	#var fim = cord_para_tile(para)
	#var caminho = astar_grid.get_id_path(inicio, fim).slice(1)
	#return caminho

# Retorna uma lista com os tiles que formam uma area circular a partir de um tile central.
func area_circular(centro : Vector2i, alcance_maximo : int):
	var tiles_list : Array[Vector2i] = []
	for x in range(-alcance_maximo, alcance_maximo + 1):
		for y in range(-alcance_maximo, alcance_maximo + 1):
			var tile = Vector2i(x + centro.x, y + centro.y)
			if (abs(x) + abs(y)) <= alcance_maximo:
				tiles_list.append(tile)
	return tiles_list

# retorna uma lista com os tiles que formam uma area quadrada a partir de um tile central.
func area_quadrada(centro : Vector2i, alcance_maximo : int):
	var tiles_list : Array[Vector2i] = []
	for x in range(-alcance_maximo, alcance_maximo + 1):
		for y in range(-alcance_maximo, alcance_maximo + 1):
			var tile = Vector2i(x + centro.x, y + centro.y)
			tiles_list.append(tile)
	return tiles_list

# Coloca um tile na layer "Area".
func set_tile_area(tile : Vector2i):
	tilemap.set_cell(layers_id["Area"], tile, 2, Vector2i(0, 0))

# Apaga todos os tiles da layer "Area".
func limpa_area():
	tilemap.clear_layer(layers_id["Area"])

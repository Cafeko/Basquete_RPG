extends Node2D
class_name Quadra

@onready var tilemap : TileMap = $TileMap

var layers_id : Dictionary = {}
var astar_grid : AStarGrid2D 

func _ready():
	Global.quadra = self
	set_layers_id_dict()
	cria_astar_grid()
	prepara_navegacao()

func set_layers_id_dict():
	for l in tilemap.get_layers_count():
		var nome = tilemap.get_layer_name(l)
		layers_id[nome] = l

func cria_astar_grid():
	astar_grid = AStarGrid2D.new()
	astar_grid.region = tilemap.get_used_rect()
	astar_grid.cell_size = tilemap.tile_set.tile_size
	astar_grid.diagonal_mode = astar_grid.DIAGONAL_MODE_NEVER
	astar_grid.update()

func atualiza_navegacao_tile(tile : Vector2i):
	var tile_data = tilemap.get_cell_tile_data(layers_id["Navegacao"], tile)
	astar_grid.set_point_solid(tile, (tile_data == null))

func prepara_navegacao():
	var pos_inicial = tilemap.get_used_rect().position
	var tamanho = tilemap.get_used_rect().size
	for x in tamanho.x:
		for y in tamanho.y:
			var tile = Vector2i(x + pos_inicial.x, y + pos_inicial.y)
			var tile_data = tilemap.get_cell_tile_data(layers_id["Chao"], tile)
			if tile_data != null:
				set_tile_navegavel(tile)
			else:
				set_tile_nao_navegavel(tile)

func set_tile_navegavel(tile : Vector2i):
	tilemap.set_cell(layers_id["Navegacao"], tile, 2, Vector2i(0, 0))
	atualiza_navegacao_tile(tile)

func set_tile_nao_navegavel(tile : Vector2i):
	tilemap.erase_cell(layers_id["Navegacao"], tile)
	atualiza_navegacao_tile(tile)

func tile_para_cord(tile : Vector2i):
	return tilemap.map_to_local(tile)

func cord_para_tile(cord : Vector2):
	return tilemap.local_to_map(cord)

func cria_caminho(de : Vector2, para : Vector2):
	var inicio = cord_para_tile(de)
	var fim = cord_para_tile(para)
	var caminho = astar_grid.get_id_path(inicio, fim).slice(1)
	return caminho

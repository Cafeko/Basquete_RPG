# -<cesta>---------------------------------------------------------------------------------------- #
# Cesta de basquete que o jogador pode arremessar a bola para marcar ponto.
# ------------------------------------------------------------------------------------------------ #
extends CharacterBody2D
class_name Cesta

@export var e_cesta_esquerda : bool = false

@onready var centro = $Centro
@onready var aparencia = $Aparencia

var tile_cesta : Vector2i
var tile_base : Vector2i
var time_ganha_ponto : TimeJogadores
var dificuldade : int = 0
var tile_proximos : Array[Vector2i]

func _ready():
	tile_cesta = Global.quadra.cord_para_tile(self.global_position)
	define_tile_base()
	define_tile_proximos()
# ------------------------------------------------------------------------------------------------ #

# ------------------------------------------------------------------------------------------------ #
# Preparação
func define_tile_base():
	var direcao = 0
	if e_cesta_esquerda:
		direcao = 1
	else:
		direcao = -1
	tile_base = tile_cesta + Vector2i(-1 * direcao, 2)

# Guarda em uma lista os tiles que são considerados proximos a cesta (tiles que a bola vai cair se 
# errar a cesta).
func define_tile_proximos():
	tile_proximos = []
	var direcao = 0
	if e_cesta_esquerda:
		direcao = 1
	else:
		direcao = -1
	var tiles : Array = []
	tiles.append(Vector2i(1, 0))
	tiles.append(Vector2i(2, 0))
	tiles.append(Vector2i(2, -1))
	tiles.append(Vector2i(3, -1))
	tiles.append(Vector2i(1, 1))
	tiles.append(Vector2i(2, 1))
	tiles.append(Vector2i(1, 2))
	tiles.append(Vector2i(0, 2))
	for tile in tiles:
		tile_proximos.append(tile_base + Vector2i(tile.x * direcao, tile.y))
	#Global.visual.desenha_area(tile_proximos)
	
# Defne qual time vai ganhar ponto quando a cesta for acertada.
func set_time_ganha_ponto(time : TimeJogadores):
	time_ganha_ponto = time
# ------------------------------------------------------------------------------------------------ #

# ------------------------------------------------------------------------------------------------ #
# Cesta
# Define a dificuldade da bola entrar na cesta como um valor especificado.
func set_dificuldade(valor : int):
	dificuldade = valor

# Define a dificuldade da bola entrar na cesta baseado na distancia entre a cesta e o jogador.
func define_dificuldade(tile_jogador : Vector2i):
	var distancia = tile_base - tile_jogador
	dificuldade = (abs(distancia.x) + abs(distancia.y))*10
	return dificuldade

# Informa ao controlador qual time fez ponto e a quantidde de pontos.
func bola_na_cesta(pontos_quantidade: int, forca : int):
	# Bola erra cesta.
	if  forca < dificuldade:
		# Tile proximo que a bola vai cair é pego aleatoriamente.
		Global.errou_cesta.emit(tile_proximos.pick_random())
	# Bola acerta cesta.
	else:
		Global.controlador.bola_entrou_em_cesta(time_ganha_ponto, pontos_quantidade)
# ------------------------------------------------------------------------------------------------ #

# ------------------------------------------------------------------------------------------------ #
# Aparencia
func set_contorno(valor : bool, cor : Color = Color(1, 1, 1, 1)):
	if valor:
		aparencia.bota_contorno(cor)
	else:
		aparencia.tira_contorno()

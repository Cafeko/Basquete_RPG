# -<cesta>---------------------------------------------------------------------------------------- #
# Cesta de basquete que o jogador pode arremessar a bola para marcar ponto.
# ------------------------------------------------------------------------------------------------ #
extends CharacterBody2D
class_name Cesta

@export var e_cesta_esquerda : bool = false

@onready var centro = $Centro
@onready var saida = $Saida
@onready var aparencia : Aparencia = $Aparencia

var tile_cesta : Vector2i
var tile_base : Vector2i
var time_ganha_ponto : TimeJogadores
var pontos_ganho : int
var bola : Bola
var dificuldade : int = 0
var tile_proximos : Array[Vector2i]

func _ready():
	randomize()
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

# Retorna o time que ganhar ponto quando a cesta for acertada.
func get_time_ganha_ponto():
	return time_ganha_ponto
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

# Executada quando a bola chegar na cesta.
func bola_na_cesta(bola_que_acertou : Bola, pontos_quantidade: int, forca : int):
	# Bola erra cesta.
	if  forca < dificuldade:
		# Define aleatoriamente o tile proximo que a bola vai cair.
		Global.errou_cesta.emit(tile_proximos.pick_random())
	# Bola acerta cesta.
	else:
		pontos_ganho = pontos_quantidade
		bola = bola_que_acertou
		bola.aparencia.set_visivel(false)
		aparencia.toca_animacao("BolaNaCesta")

# Executada após o fim da animação da bola entrar na cesta.
func bola_entrou_na_cesta():
	# Som celebracao.
	Global.sons.toca_som("Celebrar")
	bola.global_position = saida.global_position
	bola.aparencia.set_visivel(true)
	if e_cesta_esquerda:
		Global.acertou_cesta.emit(tile_base + Vector2i.RIGHT)
	else:
		Global.acertou_cesta.emit(tile_base + Vector2i.LEFT)
	await get_tree().create_timer(1.0).timeout
	# Informa ao controlador qual time fez ponto e a quantidde de pontos.
	Global.controlador.bola_entrou_em_cesta(time_ganha_ponto, pontos_ganho)
# ------------------------------------------------------------------------------------------------ #

# ------------------------------------------------------------------------------------------------ #
# Aparencia
func set_contorno(valor : bool, cor : Color = Color(1, 1, 1, 1)):
	if valor:
		aparencia.bota_contorno(cor)
	else:
		aparencia.tira_contorno()

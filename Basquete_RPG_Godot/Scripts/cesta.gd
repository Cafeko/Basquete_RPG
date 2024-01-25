# -<cesta>---------------------------------------------------------------------------------------- #
# Cesta de basquete que o jogador pode arremessar a bola para marcar ponto.
# ------------------------------------------------------------------------------------------------ #
extends CharacterBody2D
class_name Cesta

@export var e_cesta_esquerda : bool = false

@onready var centro = $Centro

var tile_cesta : Vector2i
var time_ganha_ponto : TimeJogadores
var dificuldade : int = 0
var tile_proximos : Array[Vector2i]

func _ready():
	tile_cesta = Global.quadra.cord_para_tile(self.global_position)
	self.global_position = Global.quadra.cordenada_centralizada(self.global_position)
	define_tile_proximos()

# Informa ao controlador qual time fez ponto e a quantidde de pontos.
func bola_na_cesta(pontos_quantidade: int, forca : int):
	# Bola erra cesta.
	if  forca < dificuldade:
		Global.errou_cesta.emit(tile_proximos.pick_random())
	# Bola acerta cesta.
	else:
		Global.controlador.bola_entrou_em_cesta(time_ganha_ponto, pontos_quantidade)
	

# Define a dificuldade da bola entrar na cesta baseado na distancia entre a cesta e o jogador.
func define_dificuldade(tile_jogador : Vector2i):
	var distancia = tile_cesta - tile_jogador
	dificuldade = (abs(distancia.x) + abs(distancia.y))*10
	return dificuldade

# Guarda em uma lista os tiles que são considerados proximos a cesta (tiles que a bola vai cair se 
# errar a cesta).
func define_tile_proximos():
	tile_proximos = []
	var direcao = 0
	if e_cesta_esquerda:
		direcao = 1
	else:
		direcao = -1
	for x in range(1,3):
		for y in range(-1, 2):
			tile_proximos.append(tile_cesta + Vector2i(x * direcao, y))

# Defne qual time vai ganhar ponto quando a cesta for acertada.
func set_time_ganha_ponto(time : TimeJogadores):
	time_ganha_ponto = time

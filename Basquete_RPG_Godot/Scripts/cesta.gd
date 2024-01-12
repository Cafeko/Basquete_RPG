# -<cesta>---------------------------------------------------------------------------------------- #
# Cesta de basquete que o jogador pode arremessar a bola para marcar ponto.
# ------------------------------------------------------------------------------------------------ #
extends CharacterBody2D
class_name Cesta

@onready var centro = $Centro

var time_ganha_ponto : TimeJogadores

func _ready():
	self.global_position = Global.quadra.cordenada_centralizada(self.global_position)

# Defne qual time vai ganhar ponto quando a cesta for acertada.
func set_time_ganha_ponto(time : TimeJogadores):
	time_ganha_ponto = time

# Informa ao controlador qual time fez ponto e a quantidde de pontos.
func bola_na_cesta(pontos_quantidade: int):
	Global.controlador.bola_entrou_em_cesta(time_ganha_ponto, pontos_quantidade)
	

# -<controle_partida>----------------------------------------------------------------------------- #
# Gerencia a partida, os tempos ,os times, turnos, pontuação e etc. 
# ------------------------------------------------------------------------------------------------ #
extends Node

var time1 : TimeJogadores
var time2 : TimeJogadores

var cesta_esq : Cesta
var cesta_dir : Cesta

var time_do_turno : TimeJogadores = null

var pontuacao_time1 : int = 0
var pontuacao_time2 : int = 0

func set_times(um : TimeJogadores, dois : TimeJogadores):
	time1 = um
	time2 = dois
	time_do_turno = time1 # (Remover depois)

func get_time_do_turno():
	return time_do_turno

func set_cestas(esq : Cesta, dir : Cesta):
	cesta_esq = esq
	cesta_dir = dir

# Define o time que vai ganhar fazer o ponto ao acertar a boa na cesta.
func define_time_cesta(time1_esquerda : bool = true):
	if time1_esquerda:
		cesta_esq.set_time_ganha_ponto(time2)
		cesta_dir.set_time_ganha_ponto(time1)
	else:
		cesta_esq.set_time_ganha_ponto(time1)
		cesta_dir.set_time_ganha_ponto(time2)

# Posiciona os jogadores para o inicio de um tempo da partida.
func posicionar_jogadores_inicio_tempo(time1_esquerda : bool = true):
	var formacao = Global.quadra.get_formacao("FormacaoPadrao")
	if time1_esquerda:
		time1.posicionar_jogadores(formacao.lado_esquerdo())
	else:
		time1.posicionar_jogadores(formacao.lado_direito())

# Da pontos para o time que marcou os pontos.
func Marcou_ponto(time : TimeJogadores, pontos : int):
	if time == time1:
		pontuacao_time1 += pontos
	elif time == time2:
		pontuacao_time2 += pontos

func print_pontos():
	print(time1.name + " - " + str(pontuacao_time1))
	print("Time2 - " + str(pontuacao_time2))

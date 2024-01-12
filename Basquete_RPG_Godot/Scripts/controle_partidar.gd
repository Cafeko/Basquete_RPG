# -<controle_partida>----------------------------------------------------------------------------- #
# Gerencia a partida, os tempos ,os times, turnos, pontuação e etc. 
# ------------------------------------------------------------------------------------------------ #
extends Node

var time1 : TimeJogadores
var time2 : TimeJogadores

var time_do_turno : TimeJogadores

var pontuacao_time1 : int = 0
var pontuacao_time2 : int = 0

func set_times(um : TimeJogadores, dois : TimeJogadores):
	time1 = um
	time2 = dois

# Posiciona os jogadores para o inicio de um tempo da partida.
func posicionar_jogadores_inicio_tempo(time1_esquerda : bool = true):
	var formacao = Global.quadra.get_formacao("FormacaoPadrao")
	if time1_esquerda:
		time1.posicionar_jogadores(formacao.lado_esquerdo())
	else:
		time1.posicionar_jogadores(formacao.lado_direito())

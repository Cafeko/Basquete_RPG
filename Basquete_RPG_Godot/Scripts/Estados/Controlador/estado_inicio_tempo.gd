# -<estado_inicio_tempo>-------------------------------------------------------------------------- #
# Estado do controlador, estado do inicio de um tempo da partida.
# ------------------------------------------------------------------------------------------------ #
extends Estado

# Executando enquanto está no estado.
func executando(_delta):
	# Posiciona os jogadores para o inicio de um tempo.
	Global.controle_partida.posicionar_jogadores_inicio_tempo(false)
	muda_estado.emit(self.name, "SelecionaJogador")

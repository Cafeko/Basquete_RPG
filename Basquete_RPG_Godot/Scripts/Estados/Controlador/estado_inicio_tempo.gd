# -<estado_inicio_tempo>-------------------------------------------------------------------------- #
# Estado do controlador, estado do inicio de um tempo da partida.
# ------------------------------------------------------------------------------------------------ #
extends Estado

# Executando enquanto está no estado.
func entrando():
	Global.quadra.prepara_navegacao()
	Global.controlador.inicio_tempo()
	muda_estado.emit(self.name, "SelecionaJogador")

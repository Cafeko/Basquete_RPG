# -<estado_inicio_tempo>-------------------------------------------------------------------------- #
# Estado do controlador, estado do inicio de um tempo da partida.
# ------------------------------------------------------------------------------------------------ #
extends Estado

# Executando enquanto está no estado.
func executando(_delta):
	Global.quadra.prepara_navegacao()
	Global.controlador.inicio_tempo()
	Global.bola.global_position = Global.quadra.get_centro_cord()
	Global.controlador.limpa_info()
	Global.controlador.limpa_interrupcao()
	muda_estado.emit(self.name, "SelecionaJogador")

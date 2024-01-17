# -<estado_pegar_bola>---------------------------------------------------------------------------- #
# Estado do controlador, que faz o jogador pegar a bola se estiver no mesmo tile que ela.
# ------------------------------------------------------------------------------------------------ #
extends Estado

# Executando enquanto está no estado.
func executando(_delta):
	var jogador = Global.controlador.get_jogador_selecionado()
	jogador.comeca_pegar_bola(Global.bola)
	muda_estado.emit(self.name, "FazendoAcao")

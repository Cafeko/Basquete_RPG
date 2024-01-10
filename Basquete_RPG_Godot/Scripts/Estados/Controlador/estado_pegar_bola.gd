# -<estado_pegar_bola>---------------------------------------------------------------------------- #
# Estado do controlador, que faz o jogador pegar a bola se estiver no mesmo tile que ela.
# ------------------------------------------------------------------------------------------------ #
extends Estado

# Executando enquanto está no estado.
func executando(_delta):
	var jogador = Global.controlador.get_jogador_selecionado()
	var jogador_tile = Global.quadra.cord_para_tile(jogador.global_position)
	var bola_tile = Global.quadra.cord_para_tile(Global.bola.global_position)
	# Se o jogador selecionado estiver no mesmo tile que a bola ele pega a bola.
	if jogador_tile == bola_tile:
		jogador.comeca_pegar_bola(Global.bola)
		muda_estado.emit(self.name, "FazendoAcao")
	else:
		muda_estado.emit(self.name, "SelecionaJogador")
	

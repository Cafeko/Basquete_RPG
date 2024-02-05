# -<estado_bloqueio_inicio>----------------------------------------------------------------------- #
# Estado do controlador, prepara as informações para o jogador e o alvo disputarem em um bloqueio.
# ------------------------------------------------------------------------------------------------ #
extends Estado

# Executado quando entra no estado.
func entrando():
	# Prepara informações.
	var agente_interrupcao = Global.controlador.get_primeira_interrupcao()
	var dificuldade = agente_interrupcao.status.bloqueio()
	var alvo = Global.bola.get_jogador_segurando()
	Global.controlador.limpa_info()
	Global.controlador.add_info("Bloqueio")
	Global.controlador.add_info([alvo, dificuldade])
	# Exibe valor da dificuldade.
	Global.ui.set_valor_adversario(str(dificuldade))
	# Destaca jogador que interrompeu.
	var tile_alvo = Global.quadra.cord_para_tile(agente_interrupcao.global_position)
	var desenha_tiles : Array[Vector2i] = [tile_alvo]
	Global.visual.desenha_area(desenha_tiles)
	muda_estado.emit(self.name, "DefinaForcaAcao")

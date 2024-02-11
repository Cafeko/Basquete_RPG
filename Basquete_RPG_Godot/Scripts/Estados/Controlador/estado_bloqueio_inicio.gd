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
	# Destaca envolvidos.
	agente_interrupcao.aparencia.set_contorno(true, Global.cor_selecionado)
	alvo.aparencia.set_contorno(true, Global.cor_selecionado)
	# Definir força do jogador que tá se movendo.
	muda_estado.emit(self.name, "DefinaForcaAcao")

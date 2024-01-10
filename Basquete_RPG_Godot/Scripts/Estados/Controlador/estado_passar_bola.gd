# -<estado_passar_bola>--------------------------------------------------------------------------- #
# Estado do controlador, que faz o jogador selecionado passar a bola para um alvo selecionado.
# ------------------------------------------------------------------------------------------------ #
extends Estado

# Executando enquanto está no estado.
func executando(_delta):
	if Input.is_action_just_pressed("mouse_esq"):
		var jogador = Global.controlador.get_jogador_selecionado()
		# Se o jogador selecionado estiver com a bola:
		if jogador.com_bola:
			# Verific o que tem onde o mouse estava no click.
			var posicao_mouse = Global.controlador.get_global_mouse_position()
			var alvo = Global.controlador.verifica_ponto(posicao_mouse)
			# Faz o jogador passa a bola;
			# Se não tinha nada alvo é nulo e bola vai parar no tile;
			# Se tinha um jogador vai passar a bola para ele.
			if alvo == null or alvo is Jogador:
				Global.controlador.set_jogador_selecionado2(alvo)
				var tile = Global.quadra.cord_para_tile(posicao_mouse)
				jogador.comeca_passar_bola(Global.bola, alvo, tile)
				muda_estado.emit(self.name, "FazendoAcao")
		else:
			muda_estado.emit(self.name, "SelecionaJogador")

extends Estado

# Executando enquanto está no estado.
func executando():
	# Ao precionar o botão esquerdo do mouse: Cria um caminho entre o jogador_selecionado e o tile
	# que estava na posição do mouse e faz o jogador começar a percorrer esse caminho.
	if Input.is_action_just_pressed("mouse_esq"):
		var posicao_mouse = Global.controlador.get_global_mouse_position()
		var jogador = Global.controlador.get_jogador_selecionado()
		var caminho = Global.quadra.cria_caminho(jogador.global_position, posicao_mouse)
		Global.controlador.conectar_acao_fim()
		jogador.comeca_mover(caminho)
		muda_estado.emit(self.name, "FazendoAcao")

extends Estado

# Executando enquanto está no estado.
func executando():
	# Ao precionar o botão esquerdo do mouse: verifica se tem um Jogador na posição global do mouse
	# muda o estado para ESCOLHE_ACAO se sim.
	if Input.is_action_just_pressed("mouse_esq"):
		var posicao_mouse = Global.controlador.get_global_mouse_position()
		var corpo = Global.controlador.verifica_ponto(posicao_mouse)
		if corpo != null:
			Global.controlador.set_jogador_selecionado(corpo)
			muda_estado.emit(self.name, "EscolheAcao")

# -<estado_selecionar_jogador>-------------------------------------------------------------------- #
# Estado do controlador, estado em que o player escolhe o jogador para fazer a ação.
# ------------------------------------------------------------------------------------------------ #
extends Estado

# Executada quando os nós estiverem prontos.
func tudo_pronto():
	Global.finalizar_turno.connect(on_finalizar_turno)

# Executado quando entra no estado.
func entrando():
	Global.controlador.set_jogador_selecionado(null)
	Global.controlador.set_jogador_selecionado2(null)
	Global.ui.exibe_fim_turno()

# Executando enquanto está no estado.
func executando(_delta):
	# Ao precionar o botão esquerdo do mouse: verifica se tem um Jogador na posição global do mouse
	# muda o estado para ESCOLHE_ACAO se sim.
	if Input.is_action_just_pressed("mouse_esq"):
		var posicao_mouse = Global.controlador.get_global_mouse_position()
		var corpo = Global.controlador.verifica_ponto(posicao_mouse)
		if corpo is Jogador and Global.controlador.jogador_no_time_do_turno(corpo) and corpo.tem_acoes():
			Global.controlador.set_jogador_selecionado(corpo)
			muda_estado.emit(self.name, "EscolheAcao")

# Executado ao sair do estado
func saindo():
	Global.ui.esconde_fim_turno()

func on_finalizar_turno():
	muda_estado.emit(self.name, "FinalizaTurno")

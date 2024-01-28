# -<estado_escolhe_acao>-------------------------------------------------------------------------- #
# Estado do controlador, exibe o menu de ações e espera o player escolher a ação que o jogador 
# selecionado vai fazer.
# ------------------------------------------------------------------------------------------------ #
extends Estado

# Executada quando os nós estiverem prontos.
func tudo_pronto():
	Global.acao_escolhida.connect(on_acao_escolhida)

# Executado quando entra no estado.
func entrando():
	# Define o lado doque o status vai aparecer.
	var jogador = Global.controlador.get_jogador_selecionado()
	var na_esq = Global.controlador.time_na_esquerda(jogador.get_time())
	# Deixa os status do jogador selecionado visivel.
	Global.ui.abre_status_jogador(na_esq)
	# Deixa o menu de escolher ação visivel.
	Global.ui.abre_menu_acoes()

# Executado ao sair do estado.
func saindo():
	# Deixa o menu de escolher ação invisivel.
	Global.ui.fecha_menu_acoes()
	# Deixa os status do jogador selecionado invisivel.
	Global.ui.fecha_status_jogador()

# Muda o estado de acordo com a ação escolhida no menu de ações.
func on_acao_escolhida(acao : String):
	var novo_estado : String
	if acao == "Mover":
		novo_estado = "MoverJogador"
	elif acao == "PassarBola":
		novo_estado = "PasseAlvo"
	elif acao == "ArremessarBola":
		novo_estado = "ArremessoAlvo"
	elif acao == "RoubarBola":
		novo_estado = "RoubarBolaAlvo"
	elif acao == "Enterrar":
		novo_estado = "EnterradaAlvo"
	elif acao == "Descansar":
		novo_estado = "DescansarJogador"
	elif acao == "FecharMenu":
		novo_estado = "SelecionaJogador"
	Global.controlador_estado_atual = novo_estado
	muda_estado.emit(self.name, novo_estado)

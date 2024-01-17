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
	# Deixa o menu de escolher ação visivel.
	Global.ui.exibe_menu_acoes()

# Executado ao sair do estado.
func saindo():
	# Deixa o menu de escolher ação invisivel.
	Global.ui.esconde_menu_acoes()

# Muda o estado de acordo com a ação escolhida no menu de ações.
func on_acao_escolhida(acao : String):
	var novo_estado : String
	if acao == "Mover":
		novo_estado = "MoverJogador"
	elif acao == "PassarBola":
		novo_estado = "PasseAlvo"
	elif acao == "ArremessarBola":
		novo_estado = "ArremessoAlvo"
	Global.controlador_estado_atual = novo_estado
	muda_estado.emit(self.name, novo_estado)

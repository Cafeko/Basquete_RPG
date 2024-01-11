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
	Global.ui.visible = true

# Executado ao sair do estado.
func saindo():
	# Deixa o menu de escolher ação invisivel.
	Global.ui.visible = false

# Muda o estado de acordo com a ação escolhida no menu de ações.
func on_acao_escolhida(acao : String):
	if acao == "Mover":
		muda_estado.emit(self.name, "MoverJogador")
	elif acao == "PegarBola":
		muda_estado.emit(self.name, "PegarBola")
	elif acao == "PassarBola":
		muda_estado.emit(self.name, "PassarBola")
	elif acao == "ArremessarBola":
		muda_estado.emit(self.name, "ArremessarBola")

extends Estado

# Executada quando o controlador for inicializado.
func controlador_pronto():
	Global.acao_escolhida.connect(on_acao_escolhida)

# Executado quando entra no estado.
func entrando():
	# Deixa o menu de escolher ação visivel.
	Global.ui.visible = true

# Executado ao sair do estado
func saindo():
	# Deixa o menu de escolher ação invisivel.
	Global.ui.visible = false

# Muda o estado de acordo com a ação escolhida no menu de ações.
func on_acao_escolhida(acao : String):
	if acao == "Mover":
		muda_estado.emit(self.name, "MoverJogador")

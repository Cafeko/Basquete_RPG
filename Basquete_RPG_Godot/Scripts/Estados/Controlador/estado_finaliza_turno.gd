extends Estado

# Executando enquanto está no estado.
func executando(_delta):
	Global.controlador.fim_de_turno()
	if Global.controlador.minutos_de_jogo() == 0:
		muda_estado.emit(self.name, "FimTempo")
	else:
		muda_estado.emit(self.name, "SelecionaJogador")

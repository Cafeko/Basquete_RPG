extends Estado

# Executando enquanto está no estado.
func executando(_delta):
	Global.controlador.fim_de_turno()
	muda_estado.emit(self.name, "SelecionaJogador")

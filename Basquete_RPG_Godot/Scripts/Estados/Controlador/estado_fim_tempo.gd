extends Estado

# Executado quando entra no estado.
func executando(_delta):
	if Global.controlador.jogo_acabou():
		get_tree().quit()
	else:
		muda_estado.emit(self.name, "InicioTempo")

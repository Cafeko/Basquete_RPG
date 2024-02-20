extends Estado

# Executado quando entra no estado.
func entrando():
	Global.controlador.timer.start(1.5)

func on_timeout():
	if Global.controlador.jogo_acabou():
		get_tree().quit()
	else:
		muda_estado.emit(self.name, "InicioTempo")

extends Estado

# Executado quando entra no estado.
func executando(_delta):
	muda_estado.emit(self.name, "InicioTempo")

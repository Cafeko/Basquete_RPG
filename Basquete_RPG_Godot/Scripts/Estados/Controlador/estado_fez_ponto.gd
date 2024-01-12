# -<estado_fazendo_acao>-------------------------------------------------------------------------- #
# Estado do controlador, estado em que a bola entrou na cesta durante um arremesso.
# ------------------------------------------------------------------------------------------------ #
extends Estado

# Executando enquanto está no estado.
func executando(_delta):
	muda_estado.emit(self.name, "InicioTempo")

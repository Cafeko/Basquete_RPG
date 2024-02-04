# -<estado_interrupcao>--------------------------------------------------------------------------- #
# Estado do controlador, enquanto tiver interrupções, vai para o estado da interrupção de acordo
# com o tipo da interrupção. 
# ------------------------------------------------------------------------------------------------ #
extends Estado

var tipo

# Executado quando entra no estado.
func entrando():
	if Global.controlador.tem_interrupcao():
		tipo = Global.controlador.get_tipo_interrupcao()
		if tipo == Global.controlador.INTERRUPCAO.NO_AR:
			muda_estado.emit(self.name, "PegaBolaNoAr")
		elif tipo == Global.controlador.INTERRUPCAO.BLOQUEIO:
			muda_estado.emit(self.name, "")
	else:
		muda_estado.emit(self.name, "FazendoAcao")

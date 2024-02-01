# -<estado_fazendo_acao>-------------------------------------------------------------------------- #
# Estado do controlador, estado em que o conrolador fica enquanto espera a ação terminar.
# (Futuramente vai poder ir para outros estados a partir desse por causa de interrupções na ação)
# ------------------------------------------------------------------------------------------------ #
extends Estado

# Executada quando os nós estiverem prontos.
func tudo_pronto():
	Global.acao_acabou.connect(on_acao_acabou)
	Global.acertou_cesta.connect(on_acertou_cesta)

func on_acao_acabou():
	muda_estado.emit(self.name, "SelecionaJogador")

func on_acertou_cesta():
	muda_estado.emit(self.name, "FezPonto")

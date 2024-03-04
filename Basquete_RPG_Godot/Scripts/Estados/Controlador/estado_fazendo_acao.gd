# -<estado_fazendo_acao>-------------------------------------------------------------------------- #
# Estado do controlador, estado em que o conrolador fica enquanto espera a ação terminar.
# (Futuramente vai poder ir para outros estados a partir desse por causa de interrupções na ação)
# ------------------------------------------------------------------------------------------------ #
extends Estado

# Executada quando os nós estiverem prontos.
func tudo_pronto():
	Global.acao_acabou.connect(on_acao_acabou)
	Global.fez_ponto.connect(on_fez_ponto)
	Global.teve_interrupcao.connect(on_teve_interrupcao)

func on_acao_acabou():
	Global.controlador.partida.reset_animacao_times()
	muda_estado.emit(self.name, "SelecionaJogador")

func on_fez_ponto():
	muda_estado.emit(self.name, "FezPonto")

func on_teve_interrupcao():
	muda_estado.emit(self.name, "Interrupcao")

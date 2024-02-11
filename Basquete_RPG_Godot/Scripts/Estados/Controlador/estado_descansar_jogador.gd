# -<estado_descansar_jogador>--------------------------------------------------------------------- #
# Estado do controlador, faz o jogador usar todas as ações que ele ainda tem para descançar,
# recuperando mais energia quanto mais ações tiver.
# ------------------------------------------------------------------------------------------------ #
extends Estado

var jogador : Jogador
var energia_recuperada : int

# Executada quando os nós estiverem prontos.
func tudo_pronto():
	Global.confirmar_acao.connect(on_confirmar_acao)
	Global.cancelar_acao.connect(on_cancelar_acao)

# Executado quando entra no estado.
func entrando():
	# Valores:
	jogador = Global.controlador.get_jogador_selecionado()
	energia_recuperada = jogador.status.ganho_de_energia()
	# Visual (Jogador): 
	jogador.aparencia.set_contorno(true, Global.cor_selecionado)
	#UI:
	Global.ui.exibe_confirmacao()

# Executado ao sair do estado
func saindo():
	Global.ui.esconde_confirmacao()
	Global.controlador.contorno_time_do_turno(false)

func on_confirmar_acao(estado_alvo : String):
	if self.name == estado_alvo:
		jogador.comeca_descansar(energia_recuperada)
		muda_estado.emit(self.name, "FazendoAcao")

func on_cancelar_acao(estado_alvo : String):
	if self.name == estado_alvo:
		muda_estado.emit(self.name, "SelecionaJogador")

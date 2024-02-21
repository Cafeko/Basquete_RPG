# -<estado_descansar_jogador>--------------------------------------------------------------------- #
# Estado do controlador, faz o jogador usar todas as ações que ele ainda tem para descançar,
# recuperando mais energia quanto mais ações tiver.
# ------------------------------------------------------------------------------------------------ #
extends Estado

var jogador : Jogador
var energia_recuperada : int

# Executado quando entra no estado.
func entrando():
	# Valores:
	jogador = Global.controlador.get_jogador_selecionado()
	energia_recuperada = jogador.status.ganho_de_energia()
	# Visual (Jogador): 
	jogador.aparencia.set_contorno(true, Global.cor_selecionado)
	# Faz jogador descansar:
	jogador.comeca_descansar(energia_recuperada)
	muda_estado.emit(self.name, "FazendoAcao")

# Executado ao sair do estado
func saindo():
	Global.controlador.contorno_time_do_turno(false)

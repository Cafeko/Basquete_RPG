# -<estado_defender_jogador>---------------------------------------------------------------------- #
# Estado do controlador, faz o jogador entrar no modo de defesa para tentar pegar a bola no ar ou
# bloquear o movimento do adversario.
# ------------------------------------------------------------------------------------------------ #
extends Estado

var jogador : Jogador
var tile_jogador : Vector2i

# Executado quando entra no estado.
func entrando():
	# Jogador:
	jogador = Global.controlador.get_jogador_selecionado()
	# Visual (Jogador): 
	jogador.aparencia.set_contorno(true, Global.cor_selecionado)
	# Faz jogador defender:
	jogador.entra_modo_defesa()
	muda_estado.emit(self.name, "SelecionaJogador")

# Executado ao sair do estado
func saindo():
	Global.controlador.contorno_time_do_turno(false)

# -<estado_defender_jogador>---------------------------------------------------------------------- #
# Estado do controlador, faz o jogador entrar no modo de defesa para tentar pegar a bola no ar ou
# bloquear o movimento do adversario.
# ------------------------------------------------------------------------------------------------ #
extends Estado

var jogador : Jogador
var tile_jogador : Vector2i

# Executada quando os nós estiverem prontos.
func tudo_pronto():
	Global.confirmar_acao.connect(on_confirmar_acao)
	Global.cancelar_acao.connect(on_cancelar_acao)

# Executado quando entra no estado.
func entrando():
	jogador = Global.controlador.get_jogador_selecionado()
	Global.ui.exibe_confirmacao()
	# Destaca o jogador selecionado.
	tile_jogador = Global.quadra.cord_para_tile(jogador.global_position)
	var tile_escolhido : Array[Vector2i] = [tile_jogador]
	Global.visual.desenha_area(tile_escolhido)

# Executado ao sair do estado
func saindo():
	Global.ui.esconde_confirmacao()
	Global.visual.limpar_linha()
	Global.visual.limpa_area()

func on_confirmar_acao(estado_alvo : String):
	if self.name == estado_alvo:
		jogador.entra_modo_defesa()
		muda_estado.emit(self.name, "SelecionaJogador")

func on_cancelar_acao(estado_alvo : String):
	if self.name == estado_alvo:
		muda_estado.emit(self.name, "SelecionaJogador")
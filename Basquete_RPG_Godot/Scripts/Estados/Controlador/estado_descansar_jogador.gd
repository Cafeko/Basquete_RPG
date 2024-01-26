# -<estado_descansar_jogador>--------------------------------------------------------------------- #
# Estado do controlador, faz o jogador usar todas as ações que ele ainda tem para descançar,
# recuperando mais energia quanto mais ações tiver.
# ------------------------------------------------------------------------------------------------ #
extends Estado

var jogador : Jogador
var tile_jogador : Vector2i
var numero_acoes : int
var energia_recuperada : int
var primeira : bool = true

# Executada quando os nós estiverem prontos.
func tudo_pronto():
	Global.confirmar_acao.connect(on_confirmar_acao)
	Global.cancelar_acao.connect(on_cancelar_acao)

# Executado quando entra no estado.
func entrando():
	primeira = true
	jogador = Global.controlador.get_jogador_selecionado()
	tile_jogador = Global.quadra.cord_para_tile(jogador.global_position)
	numero_acoes = jogador.get_acoes_disponiveis()
	energia_recuperada = jogador.status.get_energia_forca()

# Executando enquanto está no estado.
func executando(_delta):
	if primeira:
		# Verifica se tem ações
		if numero_acoes > 0:
			# Destaca o jogador selecionado.
			var tile_escolhido : Array[Vector2i] = [tile_jogador]
			Global.visual.desenha_area(tile_escolhido)
			Global.ui.exibe_confirmacao()
		else:
			muda_estado.emit(self.name, "SelecionaJogador")
		primeira = false

# Executado ao sair do estado
func saindo():
	Global.visual.limpa_area()
	Global.ui.esconde_confirmacao()

func on_confirmar_acao(estado_alvo : String):
	if self.name == estado_alvo:
		jogador.comeca_descansar(energia_recuperada)
		muda_estado.emit(self.name, "FazendoAcao")

func on_cancelar_acao(estado_alvo : String):
	if self.name == estado_alvo:
		muda_estado.emit(self.name, "SelecionaJogador")

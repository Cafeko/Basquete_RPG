# -<estado_passar_bola>--------------------------------------------------------------------------- #
# Estado do controlador,  estado em que o player escolhe o alvo do passe.
# ------------------------------------------------------------------------------------------------ #
extends Estado

var jogador : Jogador
var tile_jogador : Vector2i
var alcance_passe : int
var tiles_passe : Array[Vector2i]
var alvo_escolhido
var tile_alvo : Vector2i
var escolheu : bool = false

# Executada quando os nós estiverem prontos.
func tudo_pronto():
	Global.confirmar_acao.connect(on_confirmar_acao)
	Global.cancelar_acao.connect(on_cancelar_acao)

# Executado quando entra no estado.
func entrando():
	escolheu = false
	jogador = Global.controlador.get_jogador_selecionado()
	tile_jogador = Global.quadra.cord_para_tile(jogador.global_position)
	tile_alvo = tile_jogador
	alvo_escolhido = jogador
	alcance_passe = jogador.status.get_passe_numero_tiles()
	tiles_passe = Global.quadra.area_circular(tile_jogador, alcance_passe)
	remove_tiles_invalidos()
	tiles_passe.erase(tile_jogador)
	Global.visual.desenha_area(tiles_passe)
	Global.ui.exibe_confirmacao()

# Executando enquanto está no estado.
func executando(_delta):
	# Se o jogador selecionado estiver com a bola:
	if jogador.com_bola:
		if not Global.controlador.get_mouse_em_botao():
			if Input.is_action_just_pressed("mouse_esq"):
				if escolheu:
					set_escolheu(false)
				else:
					# Verifica o que tem onde o mouse estava no click.
					var posicao_mouse = Global.controlador.get_global_mouse_position()
					var tile = Global.quadra.cord_para_tile(posicao_mouse)
					if tile in tiles_passe:
						# Se alvo_escolhido for nulo: jogador selecionado joga bola até um tile vazio;
						# Se alvo_escolhido for um jogador: jogador selecionado passa a bola para ele.
						tile_alvo = tile
						alvo_escolhido = Global.controlador.verifica_ponto(posicao_mouse)
						if alvo_escolhido == null or alvo_escolhido is Jogador:
							if alvo_escolhido is Jogador:
								Global.controlador.set_jogador_selecionado2(alvo_escolhido)
							set_escolheu(true)
	else:
		muda_estado.emit(self.name, "SelecionaJogador")

# Executado ao sair do estado
func saindo():
	Global.visual.limpa_area()
	Global.ui.esconde_confirmacao()

# Remove os tiles fora da quadra dos tiles_passe.
func remove_tiles_invalidos():
	var tiles_validos : Array[Vector2i] = []
	for i in range(len(tiles_passe)):
		if Global.quadra.tile_em_quadra(tiles_passe[i]):
			tiles_validos.append(tiles_passe[i])
	tiles_passe = tiles_validos

# Define se escolheu ou não um alvo e muda o visual de acordo.
func set_escolheu(valor : bool):
	escolheu = valor
	if escolheu:
		Global.visual.limpa_area()
		var tile_escolhido : Array[Vector2i] = [tile_alvo]
		Global.visual.desenha_area(tile_escolhido)
	else:
		Global.visual.desenha_area(tiles_passe)
		tile_alvo = tile_jogador
		alvo_escolhido = jogador

func on_confirmar_acao(estado_alvo : String):
	if self.name == estado_alvo:
		Global.controlador.limpa_info()
		Global.controlador.limpa_interrupcao()
		Global.controlador.add_info("Passe")
		Global.controlador.add_info([Global.bola, alvo_escolhido, tile_alvo])
		muda_estado.emit(self.name, "DefinaForcaAcao")

func on_cancelar_acao(estado_alvo : String):
	if self.name == estado_alvo:
		muda_estado.emit(self.name, "SelecionaJogador")

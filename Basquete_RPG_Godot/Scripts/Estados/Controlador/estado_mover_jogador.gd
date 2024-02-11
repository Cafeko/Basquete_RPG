# -<estado_mover_jogador>------------------------------------------------------------------------- #
# Estado do controlador, estado que se define o caminho e inicia o movimento do jogador selecionado.
# ------------------------------------------------------------------------------------------------ #
extends Estado

var caminho : Array[Vector2i] = []
var jogador : Jogador
var tile_jogador : Vector2i
var definir_caminho = false
var tile_atual : Vector2i
var caminho_tamanho : int = 0

# Executada quando os nós estiverem prontos.
func tudo_pronto():
	Global.confirmar_acao.connect(on_confirmar_acao)
	Global.cancelar_acao.connect(on_cancelar_acao)

# Executado quando entra no estado.
func entrando():
	# Valores:
	caminho = []
	definir_caminho = false
	jogador = Global.controlador.get_jogador_selecionado()
	tile_jogador = Global.quadra.cord_para_tile(jogador.global_position)
	caminho_tamanho = jogador.status.get_movimento_numero_tiles()
	# UI:
	Global.ui.exibe_confirmacao()
	# Visual (Tiles):
	# Destaca tile do jogador selecionado.
	var tile_escolhido : Array[Vector2i] = [tile_jogador]
	Global.visual.desenha_area(tile_escolhido)

# Executando enquanto está no estado.
func executando(_delta):
	# Verifica se pressionou no jogador selecionado para comesar a definir o caminho.
	if Input.is_action_just_pressed("mouse_esq"):
		var posicao_mouse = Global.controlador.get_global_mouse_position()
		var tile = Global.quadra.cord_para_tile(posicao_mouse)
		if tile == tile_jogador:
			caminho = []
			Global.visual.limpar_linha()
			definir_caminho = true
			caminho.append(tile_jogador)
	# Para de definir o caminho quando soltar o botão esquerdo do mouse.
	if Input.is_action_just_released("mouse_esq"):
		definir_caminho = false
	# Enquanto estiver definindo caminho (Segurando o botão esquerdo do mouse).
	if definir_caminho:
		# Pega o tile em que o mouse está.
		var posicao_mouse = Global.controlador.get_global_mouse_position()
		var tile = Global.quadra.cord_para_tile(posicao_mouse)
		# Se o mouse foi para um novo tile:
		if tile != tile_atual:
			tile_atual = tile
			# Se o tile já está no caminho ele reduz o caminho até esse tile.
			if tile in caminho:
				caminho = caminho.slice(0, caminho.find(tile) + 1)
			# Adiciona o tile ao caminho se: ele está livre para andar, se ele está proximo e se o 
			# jogador selecionado ainda pade andar mais tiles.
			elif ta_livre_pra_andar(tile) and distancia_valida(tile)\
								and len(caminho) < caminho_tamanho + 1:
				caminho.append(tile)
			# Desenha o caminho definido.
			Global.visual.linha_desenhar_caminho(caminho)

# Executado ao sair do estado
func saindo():
	Global.ui.esconde_confirmacao()
	Global.visual.limpar_linha()
	Global.visual.limpa_area()

# Verifica se o tile está proximo do tile da ponta do caminho.
func distancia_valida(tile1 : Vector2i):
	if len(caminho) > 0 and (tile1 - caminho[-1]).length() > 1:
		return false
	else:
		return true 

# Verifica se o tile está ocupado por outro jogador.
func ta_livre_pra_andar(tile : Vector2i):
	if tile == tile_jogador or Global.quadra.tile_navegavel(tile):
		return true
	else:
		return false

func on_confirmar_acao(estado_alvo : String):
	if self.name == estado_alvo:
		Global.controlador.limpa_interrupcao()
		# Faz o jogador começar o movimento no caminho definido.
		jogador.comeca_mover(caminho)
		muda_estado.emit(self.name, "FazendoAcao")

func on_cancelar_acao(estado_alvo : String):
	if self.name == estado_alvo:
		muda_estado.emit(self.name, "SelecionaJogador")

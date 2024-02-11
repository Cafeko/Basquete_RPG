# -<estado_arremessar_bola>----------------------------------------------------------------------- #
# Estado do controlador, estado em que o player escolhe o alvo do arremesso.
# ------------------------------------------------------------------------------------------------ #
extends Estado

var jogador : Jogador
var tile_jogador : Vector2i
var alcance_arremesso : int
var tiles_arremesso : Array[Vector2i]
var escolheu : bool = false
var alvo_escolhido
var tile_alvo : Vector2i

# Executada quando os nós estiverem prontos.
func tudo_pronto():
	Global.confirmar_acao.connect(on_confirmar_acao)
	Global.cancelar_acao.connect(on_cancelar_acao)

# Executado quando entra no estado.
func entrando():
	# Valores:
	escolheu = false
	jogador = Global.controlador.get_jogador_selecionado()
	tile_jogador = Global.quadra.cord_para_tile(jogador.global_position)
	tile_alvo = Vector2i.ZERO
	alvo_escolhido = null
	# Area de alcance:
	alcance_arremesso = jogador.status.get_arremesso_numero_tiles()
	tiles_arremesso = Global.quadra.area_circular(tile_jogador, alcance_arremesso)
	remove_tiles_invalidos()
	Global.visual.desenha_area(tiles_arremesso)
	# Visual (Jogadores): 
	jogador.aparencia.set_contorno(true, Global.cor_selecionado)
	destaca_jogadores_no_alcance()
	# Visual (Cesta):
	Global.controlador.contorno_na_cesta_alvo()
	# UI:
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
					alvo_escolhido = Global.controlador.verifica_ponto(posicao_mouse)
					var tile = Global.quadra.cord_para_tile(posicao_mouse)
					if tile in tiles_arremesso and alvo_escolhido is Jogador and alvo_escolhido != jogador and Global.controlador.jogador_no_time_do_turno(alvo_escolhido):
							tile_alvo = Global.quadra.cord_para_tile(alvo_escolhido.global_position)
							Global.controlador.set_jogador_selecionado2(alvo_escolhido)
							set_escolheu(true)
					# Se o alvo for uma cesta e ela estiver no alcance:
					elif alvo_escolhido is Cesta: # and cesta_no_alcance(alvo_escolhido):
						tile_alvo = Vector2i.ZERO
						set_escolheu(true)
					else:
							tile_alvo = Vector2i.ZERO
							alvo_escolhido = null
	else:
		muda_estado.emit(self.name, "SelecionaJogador")

# Executado ao sair do estado.
func saindo():
	Global.visual.limpa_area()
	Global.ui.esconde_confirmacao()

# Retorna se a cesta está ou não no alcance do arremesso.
#func cesta_no_alcance(cesta : Cesta):
	#var tile_cesta = Global.quadra.cord_para_tile(cesta.global_position)
	#var tile = tile_cesta - tile_jogador
	#return abs(tile.x) + abs(tile.y) <= alcance_arremesso

# Remove os tiles fora da quadra dos tiles_arremesso.
func remove_tiles_invalidos():
	var tiles_validos : Array[Vector2i] = []
	for i in range(len(tiles_arremesso)):
		if Global.quadra.tile_em_quadra(tiles_arremesso[i]):
			tiles_validos.append(tiles_arremesso[i])
	tiles_arremesso = tiles_validos

# Define se escolheu ou não um alvo e muda o visual de acordo.
func set_escolheu(valor : bool):
	escolheu = valor
	if escolheu:
		Global.visual.limpa_area()
		if alvo_escolhido is Jogador or alvo_escolhido is Cesta:
			alvo_escolhido.aparencia.set_contorno(true, Global.cor_selecionado)
	else:
		Global.visual.desenha_area(tiles_arremesso)
		alvo_escolhido.aparencia.set_contorno(true, Global.cor_pode_selecionar)
		tile_alvo = Vector2i.ZERO
		alvo_escolhido = null

func destaca_jogadores_no_alcance():
	for tile in tiles_arremesso:
		var cord = Global.quadra.tile_para_cord(tile)
		var jogador_no_tile = Global.controlador.verifica_ponto(cord)
		if jogador_no_tile != null and Global.controlador.jogador_no_time_do_turno(jogador_no_tile) and jogador_no_tile != jogador:
			jogador_no_tile.aparencia.set_contorno(true, Global.cor_pode_selecionar)

func on_confirmar_acao(estado_alvo : String):
	if self.name == estado_alvo:
		if alvo_escolhido != null:
			Global.controlador.contorno_time_do_turno(false)
			Global.controlador.set_contorno_cestas(false)
			jogador.aparencia.set_contorno(true, Global.cor_selecionado)
			alvo_escolhido.aparencia.set_contorno(true, Global.cor_selecionado)
			if alvo_escolhido is Cesta:
				Global.ui.set_valor_adversario(str(alvo_escolhido.define_dificuldade(tile_jogador)))
			Global.controlador.limpa_info()
			Global.controlador.limpa_interrupcao()
			Global.controlador.add_info("Arremesso")
			Global.controlador.add_info([Global.bola, alvo_escolhido, tile_alvo])
			muda_estado.emit(self.name, "DefinaForcaAcao")

func on_cancelar_acao(estado_alvo : String):
	if self.name == estado_alvo:
		muda_estado.emit(self.name, "SelecionaJogador")

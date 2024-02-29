# -<estado_arremessar_bola>----------------------------------------------------------------------- #
# Estado do controlador, estado em que o player escolhe o alvo do arremesso.
# ------------------------------------------------------------------------------------------------ #
extends Estado

var jogador : Jogador
var tile_jogador : Vector2i
var alcance_passe : int
var tiles_passe : Array[Vector2i]
var escolheu : bool = false
var alvo_escolhido
var tile_alvo : Vector2i
var vai_jogar : bool

# Executado quando entra no estado.
func entrando():
	# Valores:
	vai_jogar = false
	escolheu = false
	jogador = Global.controlador.get_jogador_selecionado()
	tile_jogador = Global.quadra.cord_para_tile(jogador.global_position)
	tile_alvo = Vector2i.ZERO
	alvo_escolhido = null
	# Area de alcance:
	alcance_passe = jogador.status.get_passe_numero_tiles()
	tiles_passe = Global.quadra.area_circular(tile_jogador, alcance_passe)
	remove_tiles_invalidos()
	Global.visual.desenha_area(tiles_passe)
	# Visual (Jogadores): 
	jogador.aparencia.set_contorno(true, Global.cor_selecionado)
	destaca_jogadores_no_alcance()
	# Visual (Cesta):
	Global.controlador.contorno_na_cesta_alvo()

# Executando enquanto está no estado.
func executando(_delta):
# Se o jogador selecionado estiver com a bola:
	if jogador.com_bola:
		if not Global.controlador.get_mouse_em_botao():
			if Input.is_action_just_pressed("mouse_esq"):
				# Verifica o que tem onde o mouse estava no click.
				var posicao_mouse = Global.controlador.get_global_mouse_position()
				alvo_escolhido = Global.controlador.verifica_ponto(posicao_mouse, true)
				if alvo_escolhido != null:
					tile_alvo = Global.quadra.cord_para_tile(alvo_escolhido.global_position)
					if tile_alvo in tiles_passe and alvo_escolhido is Jogador and alvo_escolhido != jogador and Global.controlador.jogador_no_time_do_turno(alvo_escolhido):
							Global.controlador.set_jogador_selecionado2(alvo_escolhido)
							selecionou_alvo()
					# Se o alvo for uma cesta e ela estiver no alcance:
					elif alvo_escolhido is Cesta:
						tile_alvo = Vector2i.ZERO
						selecionou_alvo()
					else:
							muda_estado.emit(self.name, "SelecionaJogador")
				else:
					muda_estado.emit(self.name, "SelecionaJogador")
	else:
		muda_estado.emit(self.name, "SelecionaJogador")

# Executado ao sair do estado.
func saindo():
	if not vai_jogar:
		Global.controlador.contorno_time_do_turno(false)
		Global.controlador.set_contorno_cestas(false)
	Global.visual.limpa_area()

# Remove os tiles fora da quadra dos tiles_passe.
func remove_tiles_invalidos():
	var tiles_validos : Array[Vector2i] = []
	for i in range(len(tiles_passe)):
		if Global.quadra.tile_em_quadra(tiles_passe[i]):
			tiles_validos.append(tiles_passe[i])
	tiles_passe = tiles_validos

func destaca_jogadores_no_alcance():
	for tile in tiles_passe:
		var cord = Global.quadra.tile_para_cord(tile)
		var jogador_no_tile = Global.controlador.verifica_ponto(cord)
		if jogador_no_tile != null and Global.controlador.jogador_no_time_do_turno(jogador_no_tile) and jogador_no_tile != jogador:
			jogador_no_tile.aparencia.set_contorno(true, Global.cor_pode_selecionar)

func selecionou_alvo():
	if alvo_escolhido != null:
		vai_jogar = true
		Global.controlador.contorno_time_do_turno(false)
		Global.controlador.set_contorno_cestas(false)
		jogador.aparencia.set_contorno(true, Global.cor_selecionado)
		alvo_escolhido.aparencia.set_contorno(true, Global.cor_selecionado)
		if alvo_escolhido is Jogador:
			Global.controlador.limpa_info()
			Global.controlador.limpa_interrupcao()
			Global.controlador.add_info("Passe")
		elif alvo_escolhido is Cesta:
			Global.ui.set_valor_adversario(str(alvo_escolhido.define_dificuldade(tile_jogador)))
			Global.controlador.limpa_info()
			Global.controlador.limpa_interrupcao()
			Global.controlador.add_info("Arremesso")
		Global.controlador.add_info([Global.bola, alvo_escolhido, tile_alvo])
		muda_estado.emit(self.name, "DefinaForcaAcao")

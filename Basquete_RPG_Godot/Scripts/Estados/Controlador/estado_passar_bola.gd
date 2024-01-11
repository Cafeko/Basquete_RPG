# -<estado_passar_bola>--------------------------------------------------------------------------- #
# Estado do controlador, que faz o jogador selecionado passar a bola para um alvo selecionado.
# ------------------------------------------------------------------------------------------------ #
extends Estado

var jogador : Jogador
var tile_jogador : Vector2i
var alcance_passe : int
var tiles_passe : Array[Vector2i]

# Executado quando entra no estado.
func entrando():
	jogador = Global.controlador.get_jogador_selecionado()
	tile_jogador = Global.quadra.cord_para_tile(jogador.global_position)
	alcance_passe = jogador.status.get_passe_numero_tiles()
	tiles_passe = Global.quadra.area_circular(tile_jogador, alcance_passe)
	remove_tiles_passe_invalidos()
	tiles_passe.erase(tile_jogador)
	Global.visual.desenha_area(tiles_passe)

# Executando enquanto está no estado.
func executando(_delta):
	if Input.is_action_just_pressed("mouse_esq"):
		# Se o jogador selecionado estiver com a bola:
		if jogador.com_bola:
			# Verific o que tem onde o mouse estava no click.
			var posicao_mouse = Global.controlador.get_global_mouse_position()
			var tile = Global.quadra.cord_para_tile(posicao_mouse)
			if tile in tiles_passe:
				var alvo = Global.controlador.verifica_ponto(posicao_mouse)
				# Faz o jogador passa a bola;
				# Se não tinha nada alvo é nulo e bola vai parar no tile;
				# Se tinha um jogador vai passar a bola para ele.
				if alvo == null or alvo is Jogador:
					Global.controlador.set_jogador_selecionado2(alvo)
					jogador.comeca_passar_bola(Global.bola, alvo, tile)
					muda_estado.emit(self.name, "FazendoAcao")
		else:
			muda_estado.emit(self.name, "SelecionaJogador")

# Executado ao sair do estado
func saindo():
	Global.visual.limpa_area()

# Remove os tiles fora da quadra dos tiles_passe.
func remove_tiles_passe_invalidos():
	var tiles_validos : Array[Vector2i] = []
	for i in range(len(tiles_passe)):
		if Global.quadra.tile_em_quadra(tiles_passe[i]):
			tiles_validos.append(tiles_passe[i])
	tiles_passe = tiles_validos

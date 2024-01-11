# -<estado_arremessar_bola>----------------------------------------------------------------------- #
# Estado do controlador, que faz o jogador selecionado arremessar a bola para um alvo selecionado.
# ------------------------------------------------------------------------------------------------ #
extends Estado

var jogador : Jogador
var tile_jogador : Vector2i
var alcance_arremesso : int
var tiles_arremesso : Array[Vector2i]

# Executado quando entra no estado.
func entrando():
	jogador = Global.controlador.get_jogador_selecionado()
	tile_jogador = Global.quadra.cord_para_tile(jogador.global_position)
	alcance_arremesso = jogador.status.get_arremesso_numero_tiles()
	tiles_arremesso = Global.quadra.area_circular(tile_jogador, alcance_arremesso)
	remove_tiles_invalidos()
	tiles_arremesso.erase(tile_jogador)
	Global.visual.desenha_area(tiles_arremesso)

# Executando enquanto está no estado.
func executando(_delta):
	if Input.is_action_just_pressed("mouse_esq"):
		# Se o jogador selecionado estiver com a bola:
		if jogador.com_bola:
			# Verifica o que tem onde o mouse estava no click.
			var posicao_mouse = Global.controlador.get_global_mouse_position()
			var alvo = Global.controlador.verifica_ponto(posicao_mouse)
			# Se alvo for um Jogador ou um tile vazio. 
			if alvo == null or alvo is Jogador:
				# Verifica se o tile em que o mouse estava é um tile em que da para arremessar.
				var tile = Global.quadra.cord_para_tile(posicao_mouse)
				if tile in tiles_arremesso:
					if alvo is Jogador:
						Global.controlador.set_jogador_selecionado2(alvo)
					# Faz o jogador arremessar a bola e muda o estado para "FazendoAcao".
					jogador.comeca_arremessar_bola(Global.bola, alvo, tile)
					muda_estado.emit(self.name, "FazendoAcao")
		else:
			muda_estado.emit(self.name, "SelecionaJogador")

# Executado ao sair do estado.
func saindo():
	Global.visual.limpa_area()

# Remove os tiles fora da quadra dos tiles_arremesso.
func remove_tiles_invalidos():
	var tiles_validos : Array[Vector2i] = []
	for i in range(len(tiles_arremesso)):
		if Global.quadra.tile_em_quadra(tiles_arremesso[i]):
			tiles_validos.append(tiles_arremesso[i])
	tiles_arremesso = tiles_validos

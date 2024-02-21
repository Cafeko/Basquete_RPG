# -<estado_roubar_bola>--------------------------------------------------------------------------- #
# Estado do controlador, estado em que é definido um alvo adjacente ao jogador para roubar a bola.
# ------------------------------------------------------------------------------------------------ #
extends Estado

var jogador : Jogador
var tile_jogador : Vector2i
var alcance_roubo_bola : int
var alvo
var alvo_e_aliado : bool
var tiles_proximos : Array
var nada_pra_roubar : bool = true

# Executado quando entra no estado.
func entrando():
	# Valores:
	nada_pra_roubar = true
	jogador = Global.controlador.get_jogador_selecionado()
	tile_jogador = Global.quadra.cord_para_tile(jogador.global_position)
	alvo = null
	# Visual (Jogador):
	jogador.aparencia.set_contorno(true, Global.cor_selecionado)
	# Area de roubar bola:
	alcance_roubo_bola = jogador.status.get_roubo_bola_numero_tiles()
	tiles_proximos = Global.quadra.area_quadrada(tile_jogador, alcance_roubo_bola)
	tiles_proximos.erase(tile_jogador)
	# Verifica area de roubo da bola:
	# Verifica se tem algum jogador posicionado nos tiles proximos e se ele está com a bola. 
	for tile in tiles_proximos:
		var cordenada = Global.quadra.tile_para_cord(tile)
		var alvo_temporario = Global.controlador.verifica_ponto(cordenada)
		# Se o jogador proximo estiver com a bola:
		if alvo_temporario is Jogador and alvo_temporario != jogador and alvo_temporario.com_bola:
			nada_pra_roubar = false
			# Define o alvo que vai ter a bola roubada e destaca o tile em que ele está.
			alvo = alvo_temporario
			alvo.aparencia.set_contorno(true, Global.cor_selecionado)
			# Define se o alvo é um jogador do mesmo time ou não.
			alvo_e_aliado = Global.controlador.jogador_no_time_do_turno(alvo)
			break
	# Se não tiver nenhum jogador com bola dentro do alcance de roubo:
	if nada_pra_roubar:
		muda_estado.emit(self.name, "SelecionaJogador")
	# Se tiver algum jogador com bola no alcance:
	else:
		Global.controlador.limpa_info()
		Global.controlador.add_info("RoubaBola")
		if alvo_e_aliado:
			Global.controlador.add_info([Global.bola, alvo, alvo_e_aliado, 0, 0]) # bola, alvo, aliado, dificuldade, forca
			muda_estado.emit(self.name, "FazRoubarBola")
		else:
			var dificuldade = alvo.status.defesa()
			Global.ui.set_valor_adversario(str(dificuldade))
			Global.controlador.add_info([Global.bola, alvo, alvo_e_aliado, dificuldade]) # bola, alvo, aliado, dificuldade
			muda_estado.emit(self.name, "DefinaForcaAcao")

# Executado ao sair do estado
func saindo():
	Global.visual.limpa_area()

# -<estado_em_arremesso>-------------------------------------------------------------------------- #
# Estado da bola, faz a bola se movimentar até um alvo especificado, cesta pode ser alvo.
# ------------------------------------------------------------------------------------------------ #
extends Estado

@export var bola : Bola
@export var velocidade_arremesso : float

var tile_alvo : Vector2i
var cord_alvo : Vector2
var alvo = null
var pontos : int
var tile_atual : Vector2i
var pausar_movimento : bool = false

# Executada quando os nós estiverem prontos.
func tudo_pronto():
	Global.para_movimento_bola.connect(on_para_movimento)
	Global.continua_movimento_bola.connect(on_continua_movimento)
	Global.para_bola_no_ar.connect(on_para_bola_no_ar)

# Executado quando entra no estado.
func entrando():
	bola.aparencia.set_visivel(true)
	pausar_movimento = false
	alvo = bola.get_alvo()
	tile_alvo = bola.get_tile_alvo()
	# Pega cordenada do alvo dependeno do que ele é.
	if alvo is Jogador:
		cord_alvo = alvo.ponto_bola.global_position
	elif alvo is Cesta:
		cord_alvo = alvo.centro.global_position
		pontos = bola.get_pontos()
	else:
		cord_alvo = Global.quadra.tile_para_cord(tile_alvo)

# Executando enquanto está no estado.
func executando(delta):
	if not pausar_movimento:
		# Move a bola em direção ao alvo.
		bola.global_position = bola.global_position.move_toward(cord_alvo, delta * velocidade_arremesso)
		# Verifica os tiles ao redor durante o movimento.
		var novo_tile = Global.quadra.cord_para_tile(bola.global_position)
		if novo_tile != tile_atual:
			tile_atual = novo_tile
			verifica_ao_redor()
		# Quando chegar no alvo:
		if bola.global_position == cord_alvo:
			# Se alvo for vazio: bola para no chão acabando a ação de passe (futuramente vai acabar o turno).
			if alvo == null:
				Global.acao_acabou.emit()
				Global.finalizar_turno.emit()
				muda_estado.emit(self.name, "Parada")
			# Se alvo for um jogador: jogador pega a bola.
			elif alvo is Jogador:
				muda_estado.emit(self.name, "Parada")
				alvo.comeca_pegar_bola(bola)
			# Se alvo for cesta: Bola acertou a cesta.
			elif alvo is Cesta:
				muda_estado.emit(self.name, "Parada")
				alvo.bola_na_cesta(bola, pontos, bola.get_forca())

# Verifica os tiles ao redor da bola, buscando por jogadores do time adversario que estão em modo 
# de defesa para fazer as interrupções durante o movimento da bola. 
func verifica_ao_redor():
	# Define área verificada.
	var area = Global.quadra.area_quadrada(tile_atual, 1)
	area.erase(tile_atual)
	# Verifica se tem algum jogador posicionado nos tiles proximos e se eles vão tentar pegar a bola. 
	var inimigos = []
	for tile in area:
		var cordenada = Global.quadra.tile_para_cord(tile)
		var inimigo = Global.controlador.verifica_ponto(cordenada)
		if inimigo is Jogador and inimigo.get_modo_defesa() and not Global.controlador.jogador_no_time_do_turno(inimigo):
			inimigos.append(inimigo)
	# Se forem encontrados alvos: faz interrupção.
	if len(inimigos) > 0:
		on_para_movimento()
		Global.controlador.interrupcao_tipo = Global.controlador.INTERRUPCAO.NO_AR
		for i in inimigos:
			Global.controlador.add_interrupcao(i)
		Global.teve_interrupcao.emit()

func on_para_bola_no_ar():
	muda_estado.emit(self.name, "Parada")

func on_para_movimento():
	pausar_movimento = true

func on_continua_movimento():
	pausar_movimento = false

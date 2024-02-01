# -<estado_em_rebateu>---------------------------------------------------------------------------- #
# Estado da bola, quando a bola chega na cesta, mas não entra, bola vai para um dos tiles proximos 
# a cesta, se tiver um jogador no tile esse jogador vai pegar a bola.
# ------------------------------------------------------------------------------------------------ #
extends Estado

@export var bola : Bola
@export var velocidade_rebate : float

var tile_alvo : Vector2i
var cord_alvo : Vector2
var alvo

# Executado quando entra no estado.
func entrando():
	tile_alvo = bola.get_tile_alvo()
	cord_alvo = Global.quadra.tile_para_cord(tile_alvo)
	alvo = Global.controlador.verifica_ponto(cord_alvo)

# Executando enquanto está no estado.
func executando(delta):
	# Move a bola em direção ao alvo.
	bola.global_position = bola.global_position.move_toward(cord_alvo, delta * velocidade_rebate)
	# Quando chegar no alvo:
	if bola.global_position == cord_alvo:
		# Se alvo é nulo: bola cai no chão.
		if alvo == null:
			Global.acao_acabou.emit()
			Global.finalizar_turno.emit()
			muda_estado.emit(self.name, "Parada")
		# Se alvo for jogador: alvo pega a bola.
		elif alvo is Jogador:
			alvo.comeca_pegar_bola(bola)
			muda_estado.emit(self.name, "Parada")

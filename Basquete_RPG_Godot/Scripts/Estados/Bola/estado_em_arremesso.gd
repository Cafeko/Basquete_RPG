# -<estado_em_arremesso>--------------------------------------------------------------------------- #
# Estado da bola, faz a bola se movimentar até um alvo especificado, cesta pode ser alvo.
# ------------------------------------------------------------------------------------------------ #
extends Estado

@export var bola : Bola
@export var velocidade_arremesso : float

var tile_alvo : Vector2i
var cord_alvo : Vector2
var alvo = null

# Executado quando entra no estado.
func entrando():
	alvo = bola.get_alvo()
	# Se alvo for Jogador ou tile vazio:
	if alvo == null or alvo is Jogador:
		tile_alvo = bola.get_tile_alvo()
		cord_alvo = Global.quadra.tile_para_cord(tile_alvo)
	elif alvo is Cesta:
		cord_alvo = alvo.centro.global_position

# Executando enquanto está no estado.
func executando(delta):
	# Move a bola em direção ao alvo.
	bola.global_position = bola.global_position.move_toward(cord_alvo, delta * velocidade_arremesso)
	# Quando chegar no alvo:
	if bola.global_position == cord_alvo:
		# Se alvo for vazio: bola para no chão acabando a ação de passe (futuramente vai acabar o turno).
		if alvo == null:
			Global.acao_acabou.emit()
			muda_estado.emit(self.name, "Parada")
		# Se alvo for um jogador: jogador pega a bola.
		elif alvo is Jogador:
			alvo.comeca_pegar_bola(bola)
			muda_estado.emit(self.name, "Parada")
		# Se alvo for cesta: Bola acertou a cesta.
		elif alvo is Cesta:
			alvo.bola_na_cesta(1)
			Global.acao_acabou.emit()
			muda_estado.emit(self.name, "Parada")

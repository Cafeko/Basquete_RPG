# -<estado_em_passe>------------------------------------------------------------------------------ #
# Estado da bola, faz a bola se movimentar até um alvo especificado.
# ------------------------------------------------------------------------------------------------ #
extends Estado

@export var bola : Bola
@export var velocidade_passe : float

var tile_alvo : Vector2i
var cord_alvo : Vector2
var alvo = null

# Executada quando os nós estiverem prontos.
func tudo_pronto():
	pass

# Executado quando entra no estado.
func entrando():
	tile_alvo = bola.get_tile_alvo()
	cord_alvo = Global.quadra.tile_para_cord(tile_alvo)
	alvo = bola.get_alvo()

# Executando enquanto está no estado.
func executando(delta):
	# Move a bola em direção ao alvo.
	bola.global_position = bola.global_position.move_toward(cord_alvo, delta * velocidade_passe)
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

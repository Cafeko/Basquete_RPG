# -<estado_enterrada>----------------------------------------------------------------------------- #
# Estado da bola, estado onde a bola é enterrada na cesta.
# ------------------------------------------------------------------------------------------------ #
extends Estado

@export var bola : Bola
@export var velocidade_enterrada : float

var alvo : Cesta
var cord_alvo : Vector2
var pontos : int
var tile_jogador : Vector2

# Executado quando entra no estado.
func entrando():
	alvo = bola.get_alvo()
	tile_jogador = bola.get_tile_alvo()
	cord_alvo = alvo.centro.global_position
	pontos = bola.get_pontos()

# Executando enquanto está no estado.
func executando(delta):
	# Move a bola em direção ao alvo.
	bola.global_position = bola.global_position.move_toward(cord_alvo, delta * velocidade_enterrada)
	# Quando chegar no alvo:
	if bola.global_position == cord_alvo:
		muda_estado.emit(self.name, "Parada")
		alvo.bola_na_cesta(pontos, bola.get_forca(), [tile_jogador])

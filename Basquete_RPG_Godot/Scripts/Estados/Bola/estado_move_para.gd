# -<estado_mover_para>---------------------------------------------------------------------------- #
# Estado da bola, move a bola para um tile epecifico.
# ------------------------------------------------------------------------------------------------ #
extends Estado

@export var bola : Bola
@export var velocidade_movimento : float

var tile_alvo : Vector2i
var cord_alvo : Vector2

# Executado quando entra no estado.
func entrando():
	bola.aparencia.set_visivel(true)
	tile_alvo = bola.get_tile_alvo()
	cord_alvo = Global.quadra.tile_para_cord(tile_alvo)

# Executando enquanto está no estado.
func executando(delta):
	# Move a bola em direção ao alvo.
	bola.global_position = bola.global_position.move_toward(cord_alvo, delta * velocidade_movimento)
	# Quando chegar no alvo:
	if bola.global_position == cord_alvo:
		muda_estado.emit(self.name, "Parada")

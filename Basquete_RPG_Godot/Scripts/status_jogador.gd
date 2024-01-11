# -<status_jogador>------------------------------------------------------------------------------- #
# Guarda as informações do jogador.
# ------------------------------------------------------------------------------------------------ #
extends Node

@export var movimento_alcance : int = 1
@export var passe_alcance : int = 1

# Retorna o número de tiles que o jogador pode mover em uma ação.
func get_movimento_numero_tiles():
	return movimento_alcance

# Retorna o número de tiles de alcance do passe do jogador.
func get_passe_numero_tiles():
	return passe_alcance

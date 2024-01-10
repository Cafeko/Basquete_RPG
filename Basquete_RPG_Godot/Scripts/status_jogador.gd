# -<status_jogador>------------------------------------------------------------------------------- #
# Guarda as informações do jogador.
# ------------------------------------------------------------------------------------------------ #
extends Node

@export var movimento : int = 1

# Retorna o número de tiles que o jogador pode mover em uma ação.
func get_movimento_numero_tiles():
	return movimento

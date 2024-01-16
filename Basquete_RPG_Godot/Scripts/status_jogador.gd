# -<status_jogador>------------------------------------------------------------------------------- #
# Guarda as informações do jogador.
# ------------------------------------------------------------------------------------------------ #
extends Node

@export var passe_forca : int = 1
@export var arremesso_forca : int = 1

var movimento_alcance : int = 3
var passe_alcance : int = 5
var arremesso_alcance : int = 9

# Retorna a força maxima do passe.
func get_passe_forca():
	return passe_forca

# Retorna a força maxima do arremesso.
func get_arremesso_forca():
	return arremesso_forca

# Retorna o número de tiles que o jogador pode mover em uma ação.
func get_movimento_numero_tiles():
	return movimento_alcance

# Retorna o número de tiles de alcance do passe do jogador.
func get_passe_numero_tiles():
	return passe_alcance

# Retorna o número de tiles de alcance do arremesso do jogador.
func get_arremesso_numero_tiles():
	return arremesso_alcance

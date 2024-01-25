# -<status_jogador>------------------------------------------------------------------------------- #
# Guarda as informações do jogador.
# ------------------------------------------------------------------------------------------------ #
extends Node

@export var passe_forca : int = 1
@export var arremesso_forca : int = 1
@export var ataque_forca : int = 1
@export var defesa_forca : int = 1

var movimento_alcance : int = 4
var passe_alcance : int = 6
var arremesso_alcance : int = 9
var roubo_bola_alcance : int = 1
# ------------------------------------------------------------------------------------------------ #

# ------------------------------------------------------------------------------------------------ #
# - Força
# Retorna a força maxima do passe.
func get_passe_forca():
	return passe_forca

# Retorna a força maxima do arremesso.
func get_arremesso_forca():
	return arremesso_forca

# Retorna a força maxima do ataque.
func get_ataque_forca():
	return ataque_forca

# Retorna a força maxima da defesa.
func get_defesa_forca():
	return defesa_forca
# ------------------------------------------------------------------------------------------------ #

# ------------------------------------------------------------------------------------------------ #
# - Numero de tiles
# Retorna o número de tiles que o jogador pode mover em uma ação.
func get_movimento_numero_tiles():
	return movimento_alcance

# Retorna o número de tiles de alcance do passe do jogador.
func get_passe_numero_tiles():
	return passe_alcance

# Retorna o número de tiles de alcance do arremesso do jogador.
func get_arremesso_numero_tiles():
	return arremesso_alcance

# Retorna o número de tiles de alcance do roubo de bola do jogador.
func get_roubo_bola_numero_tiles():
	return roubo_bola_alcance

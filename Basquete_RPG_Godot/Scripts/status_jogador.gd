# -<status_jogador>------------------------------------------------------------------------------- #
# Guarda as informações do jogador.
# ------------------------------------------------------------------------------------------------ #
extends Node

@export var tipo_jogador : String = ""

var passe_forca : int = 1
var arremesso_forca : int = 1
var ataque_forca : int = 1
var defesa_forca : int = 1
var bloqueio_forca : int = 1
var no_ar_forca : int = 1
var energia_forca : int = 1

# 300 Max; passe, arremesso, ataque, defesa, bloqueio, no_ar, energia
var tipo_status : Dictionary = {"Atacante" : [40,70,40,20,10,40,90],
								"Meio" :     [60,30,40,30,30,50,60],
								"Defesa" :   [40,20,30,50,60,50,50]}

var energia : int = 1
var energia_max : int = 1

var movimento_alcance : int = 4
var passe_alcance : int = 6
var arremesso_alcance : int = 9
var roubo_bola_alcance : int = 1

func _ready():
	define_status(tipo_jogador)
# ------------------------------------------------------------------------------------------------ #
# - Status
func define_status(tipo : String):
	set_status(tipo_status[tipo])

func set_status(lista_status : Array):
	passe_forca = lista_status[0]
	arremesso_forca = lista_status[1]
	ataque_forca = lista_status[2]
	defesa_forca = lista_status[3]
	bloqueio_forca = lista_status[4]
	no_ar_forca = lista_status[5]
	energia_forca = lista_status[6]
	forca_para_energia(energia_forca)
# ------------------------------------------------------------------------------------------------ #

# ------------------------------------------------------------------------------------------------ #
# - Energia
func forca_para_energia(forca : int):
	energia = forca * 10
	energia_max = energia

func get_energia():
	return energia

func gasta_energia(valor : int):
	energia -= valor
	if energia <= 0:
		energia = 0

func ganha_energia(valor : int):
	energia += valor
	if energia > energia_max:
		energia = energia_max
# ------------------------------------------------------------------------------------------------ #

# ------------------------------------------------------------------------------------------------ #
# - Get força maxima
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

# Retorna a força maxima de bloqueio.
func get_bloqueio_forca():
	return bloqueio_forca

# Retorna a força maxima da defesa no ar.
func get_no_ar_forca():
	return no_ar_forca

# Retorna a força maxima da energia.
func get_energia_forca():
	return energia_forca
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
# ------------------------------------------------------------------------------------------------ #

# ------------------------------------------------------------------------------------------------ #
# - Defesas
# Retorna um valor aleatorio para a defesa.
func defesa():
	return round(randf_range(get_defesa_forca()/2.0, get_defesa_forca()))

# Retorna um valor aleatorio para a defesa no ar.
func defesa_no_ar():
	return round(randf_range(get_no_ar_forca()/2.0, get_no_ar_forca()))

# Retorna um valor aleatorio para o bloqueio.
func bloqueio():
	return round(randf_range(get_bloqueio_forca()/2.0, get_bloqueio_forca()))

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

# passe, arremesso, ataque, defesa, bloqueio, no_ar, energia
var tipo_status : Dictionary = {"Atacante" : [40,100,40,30,10,20,60],
								"Meio" :     [60,40,40,40,40,40,40],
								"Defesa" :   [40,30,50,40,60,50,30]}

var energia : int = 1
var energia_max : int = 1
var cansado : bool = false

var movimento_alcance : int = 4
var passe_alcance : int = 9
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
	energia_max = forca * 10
	energia = energia_max

func get_energia():
	return energia

func get_energia_max():
	return energia_max

func ta_cansado():
	return cansado

func ganho_de_energia():
	return 50

func gasta_energia(valor : int):
	energia -= valor
	if energia <= 0:
		energia = 0
		cansado = true

func ganha_energia(valor : int):
	energia += valor
	if cansado and energia >= round(energia_max/2.0):
		cansado = false
	if energia > energia_max:
		energia = energia_max
# ------------------------------------------------------------------------------------------------ #

# ------------------------------------------------------------------------------------------------ #
# - Get força maxima
# Retorna a força maxima do passe.
func get_passe_forca():
	if cansado:
		return round(passe_forca/2.0)
	else:
		return passe_forca

# Retorna a força maxima do arremesso.
func get_arremesso_forca():
	if cansado:
		return round(arremesso_forca/2.0)
	else:
		return arremesso_forca

# Retorna a força maxima do ataque.
func get_ataque_forca():
	if cansado:
		return round(ataque_forca/2.0)
	else:
		return ataque_forca

# Retorna a força maxima da defesa.
func get_defesa_forca():
	if cansado:
		return round(defesa_forca/2.0)
	else:
		return defesa_forca

# Retorna a força maxima de bloqueio.
func get_bloqueio_forca():
	if cansado:
		return round(bloqueio_forca/2.0)
	else:
		return bloqueio_forca

# Retorna a força maxima da defesa no ar.
func get_no_ar_forca():
	if cansado:
		return round(no_ar_forca/2.0)
	else:
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

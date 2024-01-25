# -<barra_forca>---------------------------------------------------------------------------------- #
# Barra que define a potencia de uma ação, dependendo a área em que a barra parar.
# ------------------------------------------------------------------------------------------------ #
extends Node2D

@onready var barra = $ColorRect/Control/Barra
@onready var container = $ColorRect/Control/Container

var centro_container
var distancia_maxima : float
var mover : bool = false
var velocidade_barra : float = 600

var areas : Array[String]
var area_distancias : Dictionary = {}
var area_atual : String = ""

var potencia_atual : float = 0

var posicao_barra : float
var direcao_barra : int = -1

func _ready():
	Global.barra_forca = self
	centro_container = get_container_centro()
	distancia_maxima = container.size.y / 2
	define_areas()
	reset_barra_forca()
	#comeca_mover()

func _physics_process(delta):
	if mover:
		movendo(delta)
	#if Input.is_action_just_pressed("mouse_esq"):
		#parar_mover()
		#print(area_atual)

# Retorna a barra de força para um estado padrão.
func reset_barra_forca():
	posicao_barra = distancia_maxima
	set_barra_posicao_y(posicao_barra)
	direcao_barra = -1
	area_atual = ""
	potencia_atual = 0
	mover = false

# Define a posição y da barra, concidenardo o offset do pivot. 
func set_barra_posicao_y(posicao_y : float):
	barra.position.y = (centro_container.y + posicao_y) - barra.pivot_offset.y

# Retorna a posição y da barra.
func get_barra_posicao_y():
	return barra.position.y + barra.pivot_offset.y

# Retorna a distancia entre barra e o centro do container.
func distancia_barra_centro():
	return get_barra_posicao_y() - centro_container.y

# Retorna a distancia entre a posição especificada e o centro do container.
func distancia_posicao_centro(posicao_y : float):
	return posicao_y - centro_container.y

# Retorna a as cordenadas do centro do container.
func get_container_centro():
	return container.position + container.pivot_offset

# Prepara as areas e a distancia maxima que a barra deve estar do centro para estar dentro das areas.
func define_areas():
	for cor in container.get_children():
		var nome : String = cor.name
		areas.append(nome)
		area_distancias[nome] = abs(distancia_posicao_centro(cor.position.y))
	areas.reverse()

# Retorna a cor da area em que a barra está.
func area_da_barra():
	var distancia = abs(distancia_barra_centro())
	for cor in areas:
		var area_distancia = area_distancias[cor]
		if distancia <= area_distancia:
			return cor

# Retorna a potencia de acordo com a área especificada.
func get_potencia(distancia: float):
	return 1.0 - (abs(distancia) / 100)

# Retorna a potencia atual.
func get_potencia_atual():
	return potencia_atual

# Retorna a área atual.
func get_area_atual():
	return area_atual

# Faz a barra comaçar a mover.
func comeca_mover():
	mover = true

# Movimenta a barra dentro dos limites do container.
func movendo(delta):
	posicao_barra += delta * velocidade_barra * direcao_barra
	if posicao_barra >= 100:
		posicao_barra = 100
		direcao_barra = -1
	elif posicao_barra <= -100:
		posicao_barra = -100
		direcao_barra = 1
	set_barra_posicao_y(posicao_barra)

# Faz a barra parar de mover, registrando a area que ela parou e a potencia dela. 
func parar_mover():
	mover = false
	area_atual = area_da_barra()
	if area_atual == "Azul":
		potencia_atual = 1.0
	else:
		potencia_atual = get_potencia(distancia_barra_centro())

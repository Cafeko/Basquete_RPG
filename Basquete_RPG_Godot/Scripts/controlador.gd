# -<controlador>---------------------------------------------------------------------------------- #
# Gerencia os estados do jogo e trata os inputs do usuario.
# ------------------------------------------------------------------------------------------------ #
extends Node2D

@export var time1 : TimeJogadores
@export var time2 : TimeJogadores

@onready var maquina_estados = $MaquinaEstados
@onready var partida = $ControlePartidar

var mouse_em_botao : bool = false
var jogador_selecionado = null
var jogador_selecionado2 = null

func _ready():
	Global.controlador = self
	Global.controle_partida = partida
	partida.set_times(time1, time2)
	maquina_estados.executar_tudo_pronto()

# Verifica se em um ponto/cordenada especifica tem algum corpo, o retornando se sim.
func verifica_ponto(ponto : Vector2):
	var space = get_world_2d().direct_space_state
	var ponto_fisico : PhysicsPointQueryParameters2D = PhysicsPointQueryParameters2D.new()
	ponto_fisico.position = ponto
	ponto_fisico.set_collide_with_bodies(true)
	var resultado = space.intersect_point(ponto_fisico, 1)
	if resultado != []:
		return resultado[0]["collider"]
	else:
		return null

func set_jogador_selecionado(jogador : Jogador):
	jogador_selecionado = jogador

func get_jogador_selecionado():
	return jogador_selecionado

func set_jogador_selecionado2(jogador : Jogador):
	jogador_selecionado2 = jogador

func get_jogador_selecionado2():
	return jogador_selecionado2

# Define se o mouse está em um botão ou não.
func set_mouse_em_botao(valor : bool):
	mouse_em_botao = valor

# Retorna se o mouse está em um botão ou não.
func get_mouse_em_botao():
	return mouse_em_botao

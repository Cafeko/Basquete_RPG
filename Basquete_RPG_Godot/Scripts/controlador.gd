# -<ucontrolador>--------------------------------------------------------------------------------- #
# Gerencia os estados do jogo e trata os inputs do usuario.
# ------------------------------------------------------------------------------------------------ #
extends Node2D

@export var bola : CharacterBody2D

@onready var maquina_estados = $MaquinaEstados

var jogador_selecionado = null
var jogador_selecionado2 = null

func _ready():
	Global.controlador = self
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

# -<controlador>---------------------------------------------------------------------------------- #
# Gerencia os estados do jogo e trata os inputs do usuario.
# ------------------------------------------------------------------------------------------------ #
extends Node2D

@export var time1 : TimeJogadores
@export var time2 : TimeJogadores
@export var cesta_esquerda : Cesta
@export var cesta_direita : Cesta

@onready var maquina_estados = $MaquinaEstados
@onready var partida = $ControlePartidar

var mouse_em_botao : bool = false
var jogador_selecionado = null
var jogador_selecionado2 = null
var guarda_info : Array = []

func _ready():
	Global.controlador = self
	partida.set_times(time1, time2)
	partida.set_cestas(cesta_esquerda, cesta_direita)
	maquina_estados.executar_tudo_pronto()
# ------------------------------------------------------------------------------------------------ #

# ------------------------------------------------------------------------------------------------ #
# Verifica se em um ponto/cordenada especifica tem algum jogador, o retornando se sim.
func verifica_ponto(ponto : Vector2):
	var space = get_world_2d().direct_space_state
	var ponto_fisico : PhysicsPointQueryParameters2D = PhysicsPointQueryParameters2D.new()
	ponto_fisico.set_exclude([Global.bola])
	ponto_fisico.position = ponto
	ponto_fisico.set_collide_with_bodies(true)
	var resultado = space.intersect_point(ponto_fisico, 1)
	if resultado != []:
		return resultado[0]["collider"]
	else:
		return null

# Retorna se o jogador está no time que está agindo no turno atual.
func jogador_no_time_do_turno(jogador : Jogador):
	var time_turno = partida.get_time_do_turno()
	return time_turno == jogador.get_time()

# Retorna se o jogador está no mesmo tile que a bola.
func jogador_em_bola(jogador : Jogador):
	var tile_jogador = Global.quadra.cord_para_tile(jogador.global_position)
	var tile_bola = Global.quadra.cord_para_tile(Global.bola.global_position)
	return tile_jogador == tile_bola

func inicio_tempo(time1_esquerda : bool = true):
	partida.reset_acoes_times()
	partida.posicionar_jogadores_inicio_tempo(time1_esquerda)
	partida.define_time_cesta(time1_esquerda)
	partida.time_do_turno = partida.time1 # (Remover depois)

func fim_de_turno():
	partida.reset_acoes_time(partida.time_do_turno)
	partida.troca_time_do_turno()

# Executado quando a bola entra na cesta.
func bola_entrou_em_cesta(time : TimeJogadores, pontos: int):
	partida.Marcou_ponto(time, pontos)
	partida.print_pontos()
	Global.acertou_cesta.emit()

# Adiciona informações a lista de informações "guarda_info".
func add_info(info):
	if info is Array:
		for i in info:
			guarda_info.append(i)
	else:
		guarda_info.append(info)

# Limpa a lista de informações "guarda_info".
func limpa_info():
	guarda_info.clear()
# ------------------------------------------------------------------------------------------------ #

# ------------------------------------------------------------------------------------------------ #
# - Set/Get:
# Retorna a lista de informações "guarda_info".
func get_info():
	return guarda_info

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

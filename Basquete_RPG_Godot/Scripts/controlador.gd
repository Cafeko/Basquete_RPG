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

enum INTERRUPCAO{NADA, NO_AR, BLOQUEIO}
var interrupcao_lista : Array = []
var interrupcao_tipo = INTERRUPCAO.NADA

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
# Interrupção:
func add_interrupcao(inte):
	interrupcao_lista.append(inte)

func limpa_interrupcao():
	interrupcao_lista.clear()

func get_primeira_interrupcao():
	return interrupcao_lista.front()

func pop_primeira_interrupcao():
	return interrupcao_lista.pop_front()

func tem_interrupcao():
	return len(interrupcao_lista) > 0

func get_tipo_interrupcao():
	return interrupcao_tipo
# ------------------------------------------------------------------------------------------------ #

# ------------------------------------------------------------------------------------------------ #
# Relacionadas a partida:
# - Geral
# Retorna se o jogador está no time que está agindo no turno atual.
func jogador_no_time_do_turno(jogador : Jogador):
	var time_turno = partida.get_time_do_turno()
	return time_turno == jogador.get_time()

# Retorna se o jogador está no mesmo tile que a bola.
func jogador_em_bola(jogador : Jogador):
	var tile_jogador = Global.quadra.cord_para_tile(jogador.global_position)
	var tile_bola = Global.quadra.cord_para_tile(Global.bola.global_position)
	return tile_jogador == tile_bola

func define_time_do_turno(time : TimeJogadores):
	partida.set_time_do_turno(time)
	partida.entra_novo_turno(time)

# Retorna se o time está no lado esquerdo ou não
func time_na_esquerda(time : TimeJogadores):
	return partida.e_time_da_esquerda(time)

# Retorna o time adversario ao time especificado.
func time_adversario(time : TimeJogadores):
	return partida.get_time_adversario(time)

# Faz os jogadores do time pegarem a bola, se possivel.
func time_pega_bola(time : TimeJogadores):
	partida.time_pega_bola(time)

# - Fim de turno
func fim_de_turno():
	partida.troca_time_do_turno()
	partida.entra_novo_turno(partida.time_do_turno)

# - Inicio de tempo 
func inicio_tempo(time1_esquerda : bool = true):
	partida.set_time1_esq(time1_esquerda)
	partida.posiciona_jogadores(partida.time1, "FormacaoPadrao", time1_esquerda)
	partida.posiciona_jogadores(partida.time2, "FormacaoPadrao", !(time1_esquerda))
	partida.define_time_cesta(time1_esquerda)
	partida.reset_acoes_times()
	partida.time_do_turno = partida.time1 # (Remover depois)

# - Fez cesta
# Executado quando a bola entra na cesta.
func bola_entrou_em_cesta(time : TimeJogadores, pontos: int):
	limpa_info()
	add_info([time, pontos])
	Global.fez_ponto.emit()

# Marca ponto para o time especificado.
func marcar_pontos(time : TimeJogadores, pontos: int):
	partida.Marcou_ponto(time, pontos)
	partida.print_pontos()

# Posiciona os jogadores após uma cesta ter sido feita.
func formacao_pos_ponto(time_fez_ponto : TimeJogadores, outro_time : TimeJogadores):
	partida.posiciona_jogadores(time_fez_ponto, "FormacaoPadrao", partida.e_time_da_esquerda(time_fez_ponto))
	partida.posiciona_jogadores(outro_time, "FormacaoNaCesta", partida.e_time_da_esquerda(outro_time))

# Posiciona bola para o jogador do time que tomou a cesta pegar.
func posiciona_bola_pos_ponto(na_esquerda : bool = true):
	if na_esquerda:
		Global.bola.global_position = Global.quadra.get_esq_centro_cord()
	else:
		Global.bola.global_position = Global.quadra.get_dir_centro_cord()

# Faz o jogador que vai passar a bola para começãr o jogo novamente não poder se mover.
func jogador_nao_move_pos_ponto(time):
	var jogador : Jogador = time.get_jogador_arremesso_inicial()
	jogador.set_pode_mover(false)
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

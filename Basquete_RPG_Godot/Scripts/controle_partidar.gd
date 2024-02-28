# -<controle_partida>----------------------------------------------------------------------------- #
# Gerencia a partida, os tempos ,os times, turnos, pontuação e etc. 
# ------------------------------------------------------------------------------------------------ #
extends Node

var time1 : TimeJogadores
var time2 : TimeJogadores

var time1_esq : bool = true

var cesta_esq : Cesta
var cesta_dir : Cesta

var time_do_turno : TimeJogadores = null
var comecou_turno_com_bola : TimeJogadores = null

var pontuacao_time1 : int = 0
var pontuacao_time2 : int = 0

var periodo_minutos : int
var minutos_atual : int
var numero_periodos : int
var periodo_atual : int

func set_times(um : TimeJogadores, dois : TimeJogadores):
	time1 = um
	time2 = dois

func set_time1_esq(valor : bool):
	time1_esq = valor

func e_time_da_esquerda(time : TimeJogadores):
	if time1_esq:
		return time == time1
	else:
		return not time == time1

func set_time_do_turno(time : TimeJogadores):
	if time == time1:
		time_do_turno = time1
	elif time == time2:
		time_do_turno = time2

func troca_time_do_turno():
	var time = get_time_adversario(time_do_turno)
	time_do_turno = time

# Retorna de que time é o turno.
func get_time_do_turno():
	return time_do_turno

# Retorna o time que está enfrentando o time especificado.
func get_time_adversario(time : TimeJogadores):
	if time == time1:
		return time2
	else:
		return time1

func get_time_ganhando():
	if pontuacao_time1 > pontuacao_time2:
		return time1
	elif pontuacao_time1 < pontuacao_time2:
		return time2
	else:
		return null

func set_cestas(esq : Cesta, dir : Cesta):
	cesta_esq = esq
	cesta_dir = dir

func get_cesta_alvo(time : TimeJogadores):
	if time == cesta_esq.get_time_ganha_ponto():
		return cesta_esq
	else:
		return cesta_dir

func set_periodo_minutos(valor : int):
	periodo_minutos = valor

func passa_minuto():
	minutos_atual -= 1

func reset_minutos():
	minutos_atual = periodo_minutos

func get_minutos():
	return minutos_atual

func set_numero_periodos(valor : int):
	numero_periodos = valor

func set_periodo_atual(valor : int):
	periodo_atual = valor

func get_periodo():
	return periodo_atual

func get_periodo_maximo():
	return numero_periodos

func novo_periodo():
	periodo_atual += 1

# Define o time que vai ganhar fazer o ponto ao acertar a boa na cesta.
func define_time_cesta(time1_esquerda : bool = true):
	if time1_esquerda:
		cesta_esq.set_time_ganha_ponto(time2)
		cesta_dir.set_time_ganha_ponto(time1)
	else:
		cesta_esq.set_time_ganha_ponto(time1)
		cesta_dir.set_time_ganha_ponto(time2)

# Posiciona os jogadores de acordo com a formação indicada.
func posiciona_jogadores(time : TimeJogadores, formacao_nome : String, na_esquerda : bool = true):
	var formacao = Global.quadra.get_formacao(formacao_nome)
	if na_esquerda:
		time.posicionar_jogadores(formacao.lado_esquerdo())
	else:
		time.posicionar_jogadores(formacao.lado_direito())

func times_entra_novo_turno():
	reset_acoes_time(time1)
	time_sai_modo_defesa(time1)
	time_pode_mover(time1)
	reset_acoes_time(time2)
	time_sai_modo_defesa(time2)
	time_pode_mover(time2)

func entra_novo_turno(time : TimeJogadores):
	reset_acoes_time(time)
	time_sai_modo_defesa(time)
	time_pode_mover(time)

# Set o contorno em um time especifico.
func contorno_time(time : TimeJogadores, valor : bool):
	time.contorno_jogadores(valor)

# Faz o time resetar o numero de ações que os jogadores podem fazer.
func reset_acoes_time(time : TimeJogadores):
	time.reset_acoes()

# Faz os dois times resetarem o numero de ações que os jogadores podem fazer.
func reset_acoes_times():
	time1.reset_acoes()
	time2.reset_acoes()

# Muda o modo de defesa do time.
func time_sai_modo_defesa(time : TimeJogadores):
	time.sai_modo_defesa()

func time_pode_mover(time : TimeJogadores):
	time.set_pode_mover(true)

func time_pega_bola(time : TimeJogadores):
	time.pegar_bola()

func time_sem_bola(time : TimeJogadores):
	time.sem_bola()

# Da pontos para o time que marcou os pontos.
func Marcou_ponto(time : TimeJogadores, pontos : int):
	if time == time1:
		pontuacao_time1 += pontos
	elif time == time2:
		pontuacao_time2 += pontos

# Retorna os pontos dos times.
func retorna_times_pontos():
	return [pontuacao_time1, pontuacao_time2]

func print_pontos():
	print(time1.name + " - " + str(pontuacao_time1))
	print(time2.name + " - " + str(pontuacao_time2))

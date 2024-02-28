# -<controlador>---------------------------------------------------------------------------------- #
# Gerencia os estados do jogo e trata os inputs do usuario.
# ------------------------------------------------------------------------------------------------ #
extends Node2D

@export var time1 : TimeJogadores
@export var time2 : TimeJogadores
@export var cesta_esquerda : Cesta
@export var cesta_direita : Cesta
@export var periodos : int
@export var turnos : int 

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
	randomize()
	Global.controlador = self
	partida.set_times(time1, time2)
	partida.set_cestas(cesta_esquerda, cesta_direita)
	partida.set_periodo_minutos(turnos)
	partida.set_numero_periodos(periodos)
	maquina_estados.executar_tudo_pronto()
# ------------------------------------------------------------------------------------------------ #

# ------------------------------------------------------------------------------------------------ #
# Verifica se em um ponto/cordenada especifica tem algum jogador, o retornando se sim.
func verifica_ponto(ponto : Vector2, pela_colisao : bool = false):
	var space = get_world_2d().direct_space_state
	var ponto_fisico : PhysicsPointQueryParameters2D = PhysicsPointQueryParameters2D.new()
	ponto_fisico.set_exclude([Global.bola])
	ponto_fisico.position = ponto
	ponto_fisico.set_collide_with_bodies(true)
	var resultado = space.intersect_point(ponto_fisico, 2)
	if resultado != []:
		var index_jogador = -1
		if pela_colisao:
			var maior_y = -1
			for i in len(resultado):
				var jogador = resultado[i]["collider"]
				if jogador.global_position.y > maior_y:
					maior_y = jogador.global_position.y
					index_jogador = i
		else:
			var tile = Global.quadra.cord_para_tile(ponto)
			for i in len(resultado):
				var jogador = resultado[i]["collider"]
				var tile_jogador = Global.quadra.cord_para_tile(jogador.global_position)
				if tile_jogador == tile:
					index_jogador = i
		if index_jogador != -1:
			return resultado[index_jogador]["collider"]
		else:
			return null
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
	Global.ui.placar_atualiza_time_do_turno_cor(time.cor)

# Retorna se o time está no lado esquerdo ou não
func time_na_esquerda(time : TimeJogadores):
	return partida.e_time_da_esquerda(time)

func time_do_turno():
	return partida.time_do_turno

# Retorna o time adversario ao time especificado.
func time_adversario(time : TimeJogadores):
	return partida.get_time_adversario(time)

# Faz os jogadores do time pegarem a bola, se possivel.
func time_pega_bola(time : TimeJogadores):
	partida.time_pega_bola(time)

func atualiza_valores_placar():
	Global.ui.placar_set_pontos(partida.retorna_times_pontos())
	Global.ui.placar_set_periodo(partida.get_periodo())
	Global.ui.placar_set_minutos(partida.get_minutos())

func set_direcao_formacao_padrao(time : TimeJogadores):
	var na_esq = partida.e_time_da_esquerda(time)
	if na_esq:
		time.set_direcao_do_time(1)
	else:
		time.set_direcao_do_time(-1)

func set_direcao_formacao_na_cesta(time : TimeJogadores):
	var na_esq = partida.e_time_da_esquerda(time)
	if na_esq:
		time.set_direcao_do_time(-1)
		time.get_jogador_arremesso_inicial().aparencia.direcao.x = 1
	else:
		time.set_direcao_do_time(1)

func minutos_de_jogo():
	return partida.get_minutos()

# - Fim de turno
func fim_de_turno():
	contorno_time_do_turno(false)
	partida.troca_time_do_turno()
	partida.entra_novo_turno(partida.time_do_turno)
	partida.passa_minuto()
	atualiza_valores_placar()
	Global.ui.placar_atualiza_time_do_turno_cor(partida.time_do_turno.cor)

# - Inicio de tempo
func inicio_tempo(time1_esquerda : bool = true):
	partida.time_do_turno = time_adversario(partida.comecou_turno_com_bola)
	partida.comecou_turno_com_bola = partida.time_do_turno
	Global.ui.placar_atualiza_time_do_turno_cor(partida.time_do_turno.cor)
	partida.set_time1_esq(time1_esquerda)
	var formacao = "FormacaoPadrao"
	if partida.time_do_turno == partida.time1:
		formacao = "FormacaoInicioTempo"
	partida.posiciona_jogadores(partida.time1, formacao, time1_esquerda)
	set_direcao_formacao_padrao(partida.time1)
	formacao = "FormacaoPadrao"
	if partida.time_do_turno == partida.time2:
		formacao = "FormacaoInicioTempo"
	partida.posiciona_jogadores(partida.time2, formacao, !(time1_esquerda))
	set_direcao_formacao_padrao(partida.time2)
	partida.define_time_cesta(time1_esquerda)
	partida.times_entra_novo_turno()
	partida.reset_minutos()
	partida.novo_periodo()
	Global.ui.placar_set_cores_times(time1.cor, time2.cor)
	atualiza_valores_placar()
	Global.controlador.posiciona_bola_inicio_tempo()
	Global.controlador.jogador_inicial_centro_inicio_tempo(partida.time_do_turno)
	Global.controlador.time_pega_bola(partida.time_do_turno)
	partida.time_sem_bola(time_adversario(partida.time_do_turno))

func primeiro_inicio_tempo(time1_esquerda : bool = true):
	partida.set_time1_esq(time1_esquerda)
	partida.posiciona_jogadores(partida.time1, "FormacaoInicioTempo", time1_esquerda)
	set_direcao_formacao_padrao(partida.time1)
	partida.posiciona_jogadores(partida.time2, "FormacaoInicioTempo", !(time1_esquerda))
	set_direcao_formacao_padrao(partida.time2)
	partida.define_time_cesta(time1_esquerda)
	partida.times_entra_novo_turno()
	partida.reset_minutos()
	partida.set_periodo_atual(1)
	Global.ui.placar_set_cores_times(time1.cor, time2.cor)
	atualiza_valores_placar()

func sorteia_time_do_turno():
	var times = [time1, time2]
	partida.time_do_turno = times.pick_random()
	partida.comecou_turno_com_bola = partida.time_do_turno
	Global.ui.placar_atualiza_time_do_turno_cor(partida.time_do_turno.cor)
	return partida.time_do_turno

func posiciona_bola_inicio_tempo():
	Global.bola.bola_vai_pro_chao()
	var jogador = partida.time_do_turno.get_jogador_inicial_centro()
	Global.bola.global_position = jogador.global_position
	jogador.comeca_pegar_bola(Global.bola)

func jogador_inicial_centro_inicio_tempo(time : TimeJogadores):
	var jogador : Jogador = time.get_jogador_inicial_centro()
	jogador.set_pode_mover(false)
	var na_esq = partida.e_time_da_esquerda(jogador.time)
	if na_esq:
		jogador.aparencia.direcao.x = -1
	else:
		jogador.aparencia.direcao.x = 1
	jogador.aparencia.atualiza_animacao()

# - Fez cesta
# Executado quando a bola entra na cesta.
func bola_entrou_em_cesta(time : TimeJogadores, pontos: int):
	limpa_info()
	add_info([time, pontos])
	Global.fez_ponto.emit()

# Marca ponto para o time especificado.
func marcar_pontos(time : TimeJogadores, pontos: int):
	partida.Marcou_ponto(time, pontos)
	atualiza_valores_placar()
	#partida.print_pontos()

# Posiciona os jogadores após uma cesta ter sido feita.
func formacao_pos_ponto(time_fez_ponto : TimeJogadores, outro_time : TimeJogadores):
	partida.posiciona_jogadores(time_fez_ponto, "FormacaoPadrao", partida.e_time_da_esquerda(time_fez_ponto))
	set_direcao_formacao_padrao(time_fez_ponto)
	partida.posiciona_jogadores(outro_time, "FormacaoNaCesta", partida.e_time_da_esquerda(outro_time))
	set_direcao_formacao_na_cesta(outro_time)

# Posiciona bola para o jogador do time que tomou a cesta pegar.
func posiciona_bola_pos_ponto(na_esquerda : bool = true):
	if na_esquerda:
		Global.bola.global_position = Global.quadra.get_esq_centro_cord()
	else:
		Global.bola.global_position = Global.quadra.get_dir_centro_cord()

# Faz o jogador que vai passar a bola para começãr o jogo novamente não poder se mover.
func jogador_arremessa_pos_ponto(time):
	var jogador : Jogador = time.get_jogador_arremesso_inicial()
	jogador.set_pode_mover(false)
	var na_esq = partida.e_time_da_esquerda(jogador.time)
	if na_esq:
		jogador.aparencia.direcao.x = 1
	else:
		jogador.aparencia.direcao.x = -1
	jogador.aparencia.atualiza_animacao()

# - Fim jogo
func jogo_acabou():
	return partida.get_periodo() >= partida.get_periodo_maximo()

func time_que_ganhou():
	return partida.get_time_ganhando()
# ------------------------------------------------------------------------------------------------ #

# ------------------------------------------------------------------------------------------------ #
# - Efeitos:
func contorno_time_do_turno(valor : bool):
	partida.contorno_time(partida.time_do_turno, valor)

func set_contorno_times(valor : bool):
	partida.contorno_time(time1, valor)
	partida.contorno_time(time2, valor)

func contorno_na_cesta_alvo():
	var cesta = partida.get_cesta_alvo(partida.time_do_turno)
	cesta.aparencia.set_contorno(true, Global.cor_pode_selecionar)

func set_contorno_cestas(valor : bool):
	cesta_esquerda.aparencia.set_contorno(valor, Global.cor_pode_selecionar)
	cesta_direita.aparencia.set_contorno(valor, Global.cor_pode_selecionar)
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

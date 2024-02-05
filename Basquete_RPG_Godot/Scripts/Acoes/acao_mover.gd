# -<acao_mover>----------------------------------------------------------------------------------- #
# Move o corpo por um caminho que foi passado na faze_de_preparacao.
# ------------------------------------------------------------------------------------------------ #
extends Acao

# Variaveis:
# - Necessarias
@export var corpo : Jogador
var caminho : Array[Vector2i]

# - Internas
@export var velocidade : float = 100
var proximo_tile : Vector2i
var proxima_cord : Vector2  
var deu_passo : bool = true
var atual : bool
var pause : bool

func _ready():
	Global.finaliza_movimento_jogador.connect(da_fim)
	Global.continua_movimento_jogador.connect(continuar)

# Usado para preparar a ação antes de começar a executar ela.
func faze_de_preparacao(info : Array):
	# Recebe o caminho que deve seguir.
	caminho = info[0]
	atual = true
	pause = false

# Usado para fazer a ação acontecer (é chamado constantemente).
func executando(delta):
	if not caminho.is_empty():
		if not pause:
			# Se tiver chegado em um tile, vai pegar a cordenada global do proximo tile.
			if deu_passo:
				deu_passo = false
				proximo_tile = caminho.front()
				proxima_cord = Global.quadra.tile_para_cord(proximo_tile)
			# Move o corpo para a proxima cordenada.
			corpo.global_position = corpo.global_position.move_toward(proxima_cord, delta * velocidade)
			# Quando o corpo chegar na proxima cordenada remove o tile do caminho.
			if corpo.global_position == proxima_cord:
				# Verifica se tem jogadores em modo de defesa que vão tentar bloquear o movimento.
				if corpo.com_bola:
					verifica_ao_redor()
				deu_passo = true
				caminho.pop_front()
	# Quando não tiver mais nada no caminho emite o sinal "fim".
	else:
		fim.emit()

# Usado pra após o fim da ação para resetar as variaveis.
func finalizacao():
	caminho = []
	proximo_tile = Vector2i.ZERO
	proxima_cord = Vector2 .ZERO
	deu_passo = true
	atual = false

# Pausa o movimento do jogador.
func pausar():
	if atual:
		pause = true

# Despausa o movimento do jogador.
func continuar(jogador : Jogador):
	if jogador == corpo:
		pause = false

# Quando executada, finaliza a ação de movimento do jogador.
func da_fim(jogador : Jogador):
	if jogador == corpo:
		fim.emit()

# Verifica os tiles ao redor do jogador, buscando por jogadores do time adversario que estão em modo 
# de defesa para fazer as interrupções durante o movimento. 
func verifica_ao_redor():
	# Define área verificada.
	var area = Global.quadra.area_quadrada(proximo_tile, 1)
	area.erase(proximo_tile)
	# Verifica se tem algum jogador posicionado nos tiles proximos e se eles vão tentar pegar a bola. 
	var inimigos = []
	for tile in area:
		var cordenada = Global.quadra.tile_para_cord(tile)
		var inimigo = Global.controlador.verifica_ponto(cordenada)
		if inimigo is Jogador and inimigo.get_modo_defesa() and not Global.controlador.jogador_no_time_do_turno(inimigo):
			inimigos.append(inimigo)
	# Se forem encontrados alvos: faz interrupção.
	if len(inimigos) > 0:
		pausar() # Pausa o movimento, pois terá uma interrupção.
		Global.controlador.interrupcao_tipo = Global.controlador.INTERRUPCAO.BLOQUEIO
		for i in inimigos:
			Global.controlador.add_interrupcao(i)
		Global.teve_interrupcao.emit()

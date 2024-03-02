# -<acao_arremessar_bola>------------------------------------------------------------------------- #
# Ação que faz a bola ser arremessada do jogador até um outro jogador alvo ou a cesta.
# ------------------------------------------------------------------------------------------------ #
extends Acao

# Variaveis:
# - Necessarias
@export var corpo : Jogador
var bola : Bola = null
var alvo
var tile_alvo : Vector2i
var forca : int
var primeira : bool

func _ready():
	Global.animacao_fim_arremesso.connect(on_animacao_fim)

# Usado para preparar a ação antes de começar a executar ela.
func faze_de_preparacao(info : Array):
	primeira = true
	bola = info[0]
	alvo = info[1]
	tile_alvo = info[2]
	forca = info[3]

# Usado para fazer a ação acontecer (é chamado constantemente).
func executando(_delta):
	if primeira:
		primeira = false
		# Define o alvo da bola e a força do arremesso.
		bola.set_alvo(alvo)
		bola.set_tile_alvo(tile_alvo)
		bola.set_forca(forca)
		# Gasta energia.
		corpo.status.gasta_energia(forca)
		# Define a quantidade de pontos que o arremesso vai dar e a dificuldade dele de acordo com a
		# posição do jogador em relação ao alvo (cesta).
		if alvo is Cesta:
			bola.set_pontos(verifica_pontos_valor())
			var tile_jogador = Global.quadra.cord_para_tile(corpo.global_position)
			alvo.define_dificuldade(tile_jogador)
		animacao_arremessar()

# Usado pra após o fim da ação para resetar as variaveis.
func finalizacao():
	bola = null
	alvo = Vector2i.ZERO

# Define quantos pontos esse arremesso vai valer dependendo da posição do jogador na quadra.
func verifica_pontos_valor():
	var distancia_jogador_cesta = (corpo.global_position - alvo.global_position).length()
	var distancia_centro_cesta = (Global.quadra.get_centro_cord() - alvo.global_position).length()
	var tile_jogador : Vector2i = Global.quadra.cord_para_tile(corpo.global_position)
	var dentro_garrafao = Global.quadra.tile_em_garrafao(tile_jogador)
	if distancia_jogador_cesta < distancia_centro_cesta and dentro_garrafao:
		return 2
	else:
		return 3

func animacao_arremessar():
	var direcao = Vector2i.ZERO
	var tile_atual = Global.quadra.cord_para_tile(corpo.global_position)
	if alvo is Cesta:
		var tile_do_alvo = alvo.tile_base
		direcao = tile_do_alvo - tile_atual
	else:
		direcao = tile_alvo - tile_atual
	corpo.aparencia.direcao = direcao
	if alvo is Jogador:
		direcao = tile_atual - tile_alvo
		alvo.aparencia.direcao = direcao
		alvo.aparencia.toca_animacao("Receber")
	corpo.aparencia.toca_animacao("Arremesso")

func on_animacao_fim(corpo_esperado):
	if corpo_esperado == corpo:
		# Som arremessar bola.
		Global.sons.toca_som("Arremesso")
		# Emite um sinal que faz a bola mudar seu estado de "ComJogador" para "EmArremesso".
		Global.arremessou_bola.emit()
		fim.emit()

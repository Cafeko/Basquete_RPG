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

# Usado para preparar a ação antes de começar a executar ela.
func faze_de_preparacao(info : Array):
	bola = info[0]
	alvo = info[1]
	tile_alvo = info[2]
	forca = info[3]

# Usado para fazer a ação acontecer (é chamado constantemente).
func executando(_delta):
	# Define o alvo da bola e a força do arremesso.
	bola.set_alvo(alvo)
	bola.set_tile_alvo(tile_alvo)
	bola.set_forca(forca)
	# Define a quantidade de pontos que o arremesso vai dar e a dificuldade dele de acordo com a
	# posição do jogador em relação ao alvo (cesta).
	if alvo is Cesta:
		bola.set_pontos(verifica_pontos_valor())
		var tile_jogador = Global.quadra.cord_para_tile(corpo.global_position)
		alvo.define_dificuldade(tile_jogador)
	# Emite um sinal que faz a bola mudar seu estado de "ComJogador" para "EmArremesso".
	Global.arremessou_bola.emit()
	fim.emit()

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

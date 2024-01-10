# -<acao_pegar_bola>------------------------------------------------------------------------------ #
# Ação que faz o jogador pegar a bola para sí. 
# ------------------------------------------------------------------------------------------------ #
extends Acao

# Variaveis:
# - Necessarias
@export var corpo : Jogador
var bola : Bola = null

# - Internas
var bola_tile : Vector2i
var corpo_tile : Vector2i

# Usado para preparar a ação antes de começar a executar ela.
func faze_de_preparacao(info : Array):
	bola = info[0]
	corpo_tile = Global.quadra.cord_para_tile(corpo.global_position)
	bola_tile = Global.quadra.cord_para_tile(bola.global_position)
	
# Usado para fazer a ação acontecer (é chamado constantemente).
func executando(_delta):
	# Se o corpo do jogador estiver no mesmo tile que a bola: marca que pegou a bola e emite um sinal
	# que faz a bola mudar de estado de "Parada" para "ComJogador".
	if corpo_tile == bola_tile:
		corpo.com_bola = true
		Global.pegou_bola.emit(corpo)
	fim.emit()

# Usado pra após o fim da ação para resetar as variaveis.
func finalizacao():
	bola = null
	bola_tile = Vector2i.ZERO
	corpo_tile = Vector2i.ZERO

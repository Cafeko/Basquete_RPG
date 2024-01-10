# -<acao_passar_bola>----------------------------------------------------------------------------- #
# Ação que faz a bola ser passada do jogador até um outro jogador alvo.
# ------------------------------------------------------------------------------------------------ #
extends Acao

# Variaveis:
# - Necessarias
@export var corpo : Jogador
var bola : Bola = null
var alvo
var tile_alvo : Vector2i

# Usado para preparar a ação antes de começar a executar ela.
func faze_de_preparacao(info : Array):
	bola = info[0]
	alvo = info[1]
	tile_alvo = info[2]

# Usado para fazer a ação acontecer (é chamado constantemente).
func executando(_delta):
	# Define o alvo da bola.
	bola.set_alvo(alvo)
	bola.set_tile_alvo(tile_alvo)
	# Emite um sinal que faz a bola mudar seu estado de "ComJogador" para "EmPasse".
	Global.passou_bola.emit()
	fim.emit()

# Usado pra após o fim da ação para resetar as variaveis.
func finalizacao():
	bola = null
	alvo = Vector2i.ZERO

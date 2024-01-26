# -<acao_enterrar_bola>--------------------------------------------------------------------------- #
# Ação que faz o jogador enterrar a bola na cesta; só pode ser feito se o jogador estiver do lado
# da cesta e a dificuldade é baseada na distancia da cesta + defesa no ar dos jogadores adversarios
# que estão acima e a baixo.
# ------------------------------------------------------------------------------------------------ #
extends Acao

# Variaveis:
# - Necessarias
@export var corpo : Jogador
var bola : Bola = null
var alvo : Cesta
var forca : int
var dificuldade : int

# - Internas
var tile_jogador : Vector2i

# Usado para preparar a ação antes de começar a executar ela.
func faze_de_preparacao(info : Array):
	bola = info[0]
	alvo = info[1]
	dificuldade = info[2]
	forca = info [3]
	tile_jogador = Global.quadra.cord_para_tile(corpo.global_position)

# Usado para fazer a ação acontecer (é chamado constantemente).
func executando(_delta):
	bola.set_alvo(alvo)
	bola.set_tile_alvo(tile_jogador) # Tile vai ser evitado se a bola rebater.
	bola.set_forca(forca)
	bola.set_pontos(2)
	alvo.set_dificuldade(dificuldade)
	Global.enterrou_bola.emit()
	fim.emit()

# Usado pra após o fim da ação para resetar as variaveis.
func finalizacao():
	tile_jogador = Vector2.ZERO

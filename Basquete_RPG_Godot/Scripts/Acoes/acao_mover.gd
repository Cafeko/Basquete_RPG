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

# Usado para preparar a ação antes de começar a executar ela.
func faze_de_preparacao(info : Array):
	# Recebe o caminho que deve seguir.
	caminho = info[0]

# Usado para fazer a ação acontecer (é chamado constantemente).
func executando(delta):
	if not caminho.is_empty():
		# Se tiver chegado em um tile, vai pegar a cordenada global do proximo tile.
		if deu_passo:
			deu_passo = false
			proximo_tile = caminho.front()
			proxima_cord = Global.quadra.tile_para_cord(proximo_tile)
		# Move o corpo para a proxima cordenada.
		corpo.global_position = corpo.global_position.move_toward(proxima_cord, delta * velocidade)
		# Quando o corpo chegar na proxima cordenada remove o tile do caminho.
		if corpo.global_position == proxima_cord:
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

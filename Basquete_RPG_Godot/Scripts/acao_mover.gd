extends Acao

@export var corpo : Jogador
@export var velocidade : float = 1

var caminho : Array[Vector2i]
var proximo_tile : Vector2i
var proxima_cord : Vector2  

signal fim

func faze_de_preparacao(info : Array):
	caminho = info[0]

func executando(delta):
	if not caminho.is_empty():
		proximo_tile = caminho.front()
		proxima_cord = Global.quadra.tile_para_cord(proximo_tile)
		corpo.global_position = corpo.global_position.move_toward(proxima_cord, delta * velocidade)
		if corpo.global_position == proxima_cord:
			caminho.pop_front()
	else:
		fim.emit()

func finalizacao():
	caminho = []
	proximo_tile = Vector2i.ZERO
	proxima_cord = Vector2 .ZERO

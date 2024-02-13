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
var primeira : bool

# Usado para preparar a ação antes de começar a executar ela.
func faze_de_preparacao(info : Array):
	primeira = true
	bola = info[0]
	corpo_tile = Global.quadra.cord_para_tile(corpo.global_position)
	bola_tile = Global.quadra.cord_para_tile(bola.global_position)
	
# Usado para fazer a ação acontecer (é chamado constantemente).
func executando(_delta):
	if primeira:
		primeira = false
		# Marca que pegou a bola e emite um sinal que faz a bola mudar de estado de "Parada" para "ComJogador".
		corpo.set_com_bola(true)
		Global.pegou_bola.emit(corpo)
		corpo.aparencia.toca_animacao("Receber")
	await get_tree().create_timer(0.7).timeout
	fim.emit()

# Usado pra após o fim da ação para resetar as variaveis.
func finalizacao():
	bola = null
	bola_tile = Vector2i.ZERO
	corpo_tile = Vector2i.ZERO

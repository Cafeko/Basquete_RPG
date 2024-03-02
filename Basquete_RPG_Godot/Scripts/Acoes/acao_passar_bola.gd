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
var forca : int
var primeira : bool

func _ready():
	Global.animacao_fim_passe.connect(on_animacao_fim)

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
		# Define o alvo da bola e a força do passe.
		bola.set_alvo(alvo)
		bola.set_tile_alvo(tile_alvo)
		bola.set_forca(forca)
		# Gasta energia.
		corpo.status.gasta_energia(forca)
		animacao_passar()

# Usado pra após o fim da ação para resetar as variaveis.
func finalizacao():
	bola = null
	alvo = Vector2i.ZERO

func animacao_passar():
	var direcao = Vector2i.ZERO
	var tile_atual = Global.quadra.cord_para_tile(corpo.global_position)
	direcao = tile_alvo - tile_atual
	corpo.aparencia.direcao = direcao
	if alvo is Jogador:
		direcao = tile_atual - tile_alvo
		alvo.aparencia.direcao = direcao
		alvo.aparencia.toca_animacao("Receber")
	corpo.aparencia.toca_animacao("Passe")

func on_animacao_fim(corpo_esperado):
	if corpo_esperado == corpo:
		# Som passa bola.
		Global.sons.toca_som("Passe")
		# Emite um sinal que faz a bola mudar seu estado de "ComJogador" para "EmPasse".
		Global.passou_bola.emit()
		fim.emit()

# -<acao_roubar_bola>----------------------------------------------------------------------------- #
# Ação que faz o jogador pegar a bola de um alvo, se alvo for aliado ele só pega a bola, caso
# contrario ele disputa pela bola com o alvo, ficando atordoado se perder.
# ------------------------------------------------------------------------------------------------ #
extends Acao

# Variaveis:
# - Necessarias
@export var corpo : Jogador
var bola : Bola = null
var alvo : Jogador
var e_aliado : bool
var dificuldade : int
var forca : int

# Usado para preparar a ação antes de começar a executar ela.
func faze_de_preparacao(info : Array):
	bola = info[0]
	alvo = info[1]
	e_aliado = info[2]
	dificuldade = info[3]
	forca = info[4]

# Usado para fazer a ação acontecer (é chamado constantemente).
func executando(_delta):
	# Alvo é aliado: apenas pega a bola.
	if e_aliado:
		# Gasta energia.
		corpo.status.gasta_energia(round(corpo.status.get_ataque_forca()/2.0))
		Global.roubou_bola.emit(corpo) # Sinal que faz a bola ir de um jogador para outro.
		alvo.perdeu_bola()
		corpo.com_bola = true
	# Alvo não é aliado: disputa pela bola, ganhando se a força for maior que a dificuldade, que é 
	# baseada na defesa do adversario).
	else:
		# Gasta energia.
		corpo.status.gasta_energia(forca)
		# Se perder:
		if forca < dificuldade:
			corpo.fica_atordoado() # Deixa jogador atordoado ao perder para o alvo. 
		# Se ganhar:
		else:
			Global.roubou_bola.emit(corpo) # Sinal que faz a bola ir de um jogador para outro.
			alvo.perdeu_bola()
			corpo.com_bola = true
	fim.emit()

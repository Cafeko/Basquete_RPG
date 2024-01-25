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
var forca : float

# Usado para preparar a ação antes de começar a executar ela.
func faze_de_preparacao(info : Array):
	bola = info[0]
	alvo = info[1]
	e_aliado = info[2]
	forca = info[3]

# Usado para fazer a ação acontecer (é chamado constantemente).
func executando(_delta):
	# Alvo é aliado:
	if e_aliado:
		Global.roubou_bola.emit(corpo) # Sinal que faz a bola ir de um jogador para outro.
		alvo.perdeu_bola()
		corpo.com_bola = true
	# Alvo não é aliado:
	else:
		# Pega defesa do alvo e compara ela com a força do ataque.
		var alvo_defesa = alvo.status.get_defesa_forca()
		# Se perder:
		if forca <= alvo_defesa:
			corpo.fica_atordoado() # Deixa jogador atordoado ao perder para o alvo. 
		# Se ganhar:
		else:
			Global.roubou_bola.emit(corpo) # Sinal que faz a bola ir de um jogador para outro.
			alvo.perdeu_bola()
			corpo.com_bola = true
	fim.emit()

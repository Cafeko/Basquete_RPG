# -<acao_defesa_no_ar>---------------------------------------------------------------------------- #
# Ação que faz o jogador, se estiver defendendo, tentar pegar a bola no ar.
# ------------------------------------------------------------------------------------------------ #
extends Acao

@export var corpo : Jogador
var bola : Bola
var dificuldade : int
var forca : int

# Usado para preparar a ação antes de começar a executar ela.
func faze_de_preparacao(info : Array):
	bola = info[0]
	dificuldade = info[1]
	forca = info[2]
	
# Usado para fazer a ação acontecer (é chamado constantemente).
func executando(_delta):
	# Gasta energia.
	corpo.status.gasta_energia(forca)
	# Defesa deu errado:
	if forca < dificuldade:
		corpo.perdeu_na_defesa()
		fim.emit()
		Global.defesa_deu_errado.emit("PegaBolaNoAr")
	# Defesa deu certo:
	else:
		fim.emit()
		Global.defesa_deu_certo.emit("PegaBolaNoAr")

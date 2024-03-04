# -<acao_bloquear>-------------------------------------------------------------------------------- #
# Ação que faz o jogador, se estiver defendendo, tentar impedir o movimento de um jogador adversario
# com a bola. 
# ------------------------------------------------------------------------------------------------ #
extends Acao

@export var corpo : Jogador
var alvo : Jogador
var dificuldade : int
var forca : int

# Usado para preparar a ação antes de começar a executar ela.
func faze_de_preparacao(info : Array):
	alvo = info[0]
	dificuldade = info[1]
	forca = info[2]
	
# Usado para fazer a ação acontecer (é chamado constantemente).
func executando(_delta):
	# Gasta energia.
	corpo.status.gasta_energia(forca)
	alvo.status.gasta_energia(dificuldade)
	# Defesa deu errado:
	if forca < dificuldade:
		corpo.perdeu_na_defesa()
		fim.emit()
		Global.defesa_deu_errado.emit("BloqueioFim")
	# Defesa deu certo:
	else:
		alvo.foi_bloqueado()
		fim.emit()
		Global.defesa_deu_certo.emit("BloqueioFim")

# Usado pra após o fim da ação para resetar as variaveis.
func finalizacao():
	pass

# -<acao_descansar>------------------------------------------------------------------------------- #
# Ação que faz o jogador gastar todas a ações que ele tem disponiveis para descansar, recuperando 
# energia de acordo com sua força de energia (valor) vezes o número de ações disponiveis.
# ------------------------------------------------------------------------------------------------ #
extends Acao

# Variaveis:
# - Necessarias
@export var corpo : Jogador
var valor : int
var numero_descansos : int

# Usado para preparar a ação antes de começar a executar ela.
func faze_de_preparacao(info : Array):
	valor = info[0]
	numero_descansos = info[1]

# Usado para fazer a ação acontecer (é chamado constantemente).
func executando(_delta):
	corpo.status.ganha_energia(valor * numero_descansos)
	print(corpo.status.energia)
	fim.emit()

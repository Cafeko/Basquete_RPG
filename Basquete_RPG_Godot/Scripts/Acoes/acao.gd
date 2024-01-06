# -<acao>----------------------------------------------------------------------------------------- #
# Usado como base para criar as ações; não faz nada sozinho.
# ------------------------------------------------------------------------------------------------ #
extends Node
class_name Acao

signal fim

# Usado para preparar a ação antes de começar a executar ela.
func faze_de_preparacao(_info : Array):
	pass

# Usado para fazer a ação acontecer (é chamado constantemente).
func executando(_delta):
	pass

# Usado pra após o fim da ação para resetar as variaveis.
func Finalizacao():
	pass

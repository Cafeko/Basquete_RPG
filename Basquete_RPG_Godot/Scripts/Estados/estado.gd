# -<estado>--------------------------------------------------------------------------------------- #
# Base para criar um estado; não faz nada sozinho.
# ------------------------------------------------------------------------------------------------ #
extends Node
class_name Estado

signal muda_estado

# Executada quando os nós estiverem prontos.
func tudo_pronto():
	pass

# Executado quando entra no estado.
func entrando():
	pass

# Executando enquanto está no estado.
func executando(_delta):
	pass

# Executado ao sair do estado
func saindo():
	pass

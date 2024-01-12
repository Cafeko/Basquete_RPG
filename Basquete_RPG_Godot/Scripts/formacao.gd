# -<formacao>------------------------------------------------------------------------------------- #
# Nó de formação que tem filhos que são marcadores que definem a posição em que os jogadores serão
# posicionados.
# ------------------------------------------------------------------------------------------------ #
extends Node2D
class_name  Formacao

# Retorna uma lista com os pontos da formação para o lado esquerdo da quadra.
func lado_esquerdo():
	self.position = Vector2(0, 0)
	self.scale = Vector2(1, 1)
	return get_pontos()

# Retorna uma lista com os pontos da formação para o lado direito da quadra.
func lado_direito():
	self.position = Vector2(1088, 576)
	self.scale = Vector2(-1, -1)
	return get_pontos()

# Retorna uma lista dos marcadores filhos.
func get_pontos():
	var lista_pontos = []
	for p in get_children():
		lista_pontos.append(p)
	return lista_pontos

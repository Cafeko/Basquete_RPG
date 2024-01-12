# -<time_jogadores>------------------------------------------------------------------------------- #
# Time que contem os jogadores do time.
# ------------------------------------------------------------------------------------------------ #
extends Node2D
class_name TimeJogadores

var jogadores_lista = []

func _ready():
	prepara_jogadores_lista()

# Coloca os jogadores do time na "jogadores_lista".
func prepara_jogadores_lista():
	for j in get_children():
		jogadores_lista.append(j)

# Posiciona os jogadores na posição dos pontos que estão na lista de pontos recebida.
func posicionar_jogadores(pontos_lista : Array):
	for i in range(len(jogadores_lista)):
		jogadores_lista[i].global_position = pontos_lista[i].global_position
		jogadores_lista[i].Ajustar_no_tile()

# -<time_jogadores>------------------------------------------------------------------------------- #
# Time que contem os jogadores do time.
# ------------------------------------------------------------------------------------------------ #
extends Node2D
class_name TimeJogadores

@export var cor : Color

var jogadores_lista = []
var jogador_arremesso_inicial : Jogador
var jogador_inicial_centro : Jogador

func _ready():
	prepara_jogadores_lista()

# Coloca os jogadores do time na "jogadores_lista".
func prepara_jogadores_lista():
	for j in get_children():
		jogadores_lista.append(j)
		j.set_time(self)
	jogador_inicial_centro = jogadores_lista[0]
	jogador_arremesso_inicial = jogadores_lista[-1]

# Posiciona os jogadores na posição dos pontos que estão na lista de pontos recebida.
func posicionar_jogadores(pontos_lista : Array):
	for i in range(len(jogadores_lista)):
		jogadores_lista[i].global_position = pontos_lista[i].global_position
		jogadores_lista[i].Ajustar_no_tile()

# Reseta o numero de ações que os jogadores do time podem fazer.
func reset_acoes():
	for i in range(len(jogadores_lista)):
		jogadores_lista[i].reset_numero_acoes()

# Faz todos os jogadores sairem do modo de defesa.
func sai_modo_defesa():
	for i in range(len(jogadores_lista)):
		jogadores_lista[i].sai_modo_defesa()

func set_pode_mover(valor : bool):
	for i in range(len(jogadores_lista)):
		jogadores_lista[i].set_pode_mover(valor)

func pegar_bola():
	var bola = Global.bola
	var bola_tile = Global.quadra.cord_para_tile(bola.global_position)
	for i in range(len(jogadores_lista)):
		var jogador = jogadores_lista[i]
		var jogador_tile = Global.quadra.cord_para_tile(jogador.global_position)
		if jogador_tile == bola_tile:
			jogador.comeca_pegar_bola(bola)

# Retorna o jogador que vai estar com a bola após o time levar uma cesta.
func get_jogador_arremesso_inicial():
	return jogador_arremesso_inicial

func get_jogador_inicial_centro():
	return jogador_inicial_centro

# Set o contorno de todos os jogadores do time.
func contorno_jogadores(valor : bool):
	for i in range(len(jogadores_lista)):
		var jogador = jogadores_lista[i]
		var tem_acao = jogador.tem_acoes()
		if tem_acao:
			jogador.aparencia.set_contorno(valor, Global.cor_pode_selecionar)
		else:
			jogador.aparencia.set_contorno(valor, Global.cor_sem_acao)

func set_direcao_do_time(x : int):
	for i in range(len(jogadores_lista)):
		jogadores_lista[i].aparencia.direcao.x = x
		jogadores_lista[i].aparencia.atualiza_animacao()

func sem_bola():
	for i in range(len(jogadores_lista)):
		jogadores_lista[i].set_com_bola(false)
		jogadores_lista[i].aparencia.atualiza_animacao()

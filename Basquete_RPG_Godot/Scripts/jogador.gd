# -<jogador>-------------------------------------------------------------------------------------- #
# Jogador controlado pelo player, faz as ações no jogo.
# ------------------------------------------------------------------------------------------------ #
extends CharacterBody2D
class_name Jogador

var acoes : Dictionary
var acao_atual : Acao = null

signal acao_fim

func _ready():
	# Centraliza o jogador no tile.
	self.global_position = Global.quadra.cordenada_centralizada(self.global_position)
	# Deixa o tile que está como não navegavel.
	var tile = Global.quadra.cord_para_tile(self.global_position)
	Global.quadra.set_tile_nao_navegavel(tile)
	# Ações
	acao_atual = get_node("Acoes").get_primeira_acao()
	acoes = get_node("Acoes").get_acoes_dict()
	# Conecta o sinal de fim.
	acoes["Mover"].fim.connect(fim_mover)

func _physics_process(delta):
	# Fica executando constantemente a ação atual.
	acao_atual.executando(delta)

# Começa a ação de Mover.
func comeca_mover(caminho : Array[Vector2i]):
	# Deixa o tile em que está no inicio do movimento como navegavel.
	var tile_atual = Global.quadra.cord_para_tile(self.global_position)
	Global.quadra.set_tile_navegavel(tile_atual)
	# Prepara a acao_atual para ser a ação de "Mover".
	acao_atual = acoes["Mover"]
	acao_atual.faze_de_preparacao([caminho])

# Dá um fim a ação de mover.
func fim_mover():
	# Deixa o tile em que está no fim do movimento como não navegavel.
	var tile = Global.quadra.cord_para_tile(self.global_position)
	Global.quadra.set_tile_nao_navegavel(tile)
	# Finaliza a acao_atual e muda ela para a ação "Parado".
	acao_atual.finalizacao()
	acao_atual = acoes["Parado"]
	# Emite um sinal informando que a ação acabou.
	acao_fim.emit()

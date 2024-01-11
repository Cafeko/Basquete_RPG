# -<jogador>-------------------------------------------------------------------------------------- #
# Jogador controlado pelo player, faz as ações no jogo.
# ------------------------------------------------------------------------------------------------ #
extends CharacterBody2D
class_name Jogador

@onready var ponto_bola = $PontoBola
@onready var status = $Status

#Ações
var acoes : Dictionary
var acao_atual : Acao = null

var com_bola : bool = false

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
	acoes["PegarBola"].fim.connect(fim_pegar_bola)
	acoes["PassarBola"].fim.connect(fim_passar_bola)
	acoes["ArremessarBola"].fim.connect(fim_arremessar_bola)

func _physics_process(delta):
	# Fica executando constantemente a ação atual.
	acao_atual.executando(delta)

# Ações:
# - Mover
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
	Global.acao_acabou.emit()

# - PegarBola
# Começa a ação de PegarBola.
func comeca_pegar_bola(bola : Bola):
	acao_atual = acoes["PegarBola"]
	acao_atual.faze_de_preparacao([bola])

# Dá um fim a ação de PegarBola.
func fim_pegar_bola():
	acao_atual.finalizacao()
	acao_atual = acoes["Parado"]
	Global.acao_acabou.emit()

# - PassarBola
# Começa a ação de PassarBola.
func comeca_passar_bola(bola : Bola, alvo, tile_alvo : Vector2i):
	# Prepara a acao_atual para ser a ação de "PassarBola".
	acao_atual = acoes["PassarBola"]
	acao_atual.faze_de_preparacao([bola, alvo, tile_alvo])

# Muda para o estado Parado após fazer o passe.
func fim_passar_bola():
	com_bola = false
	# Finaliza a acao_atual e muda ela para a ação "Parado".
	acao_atual.finalizacao()
	acao_atual = acoes["Parado"]

# - ArremessarBola
# Começa a ação de ArremessarBola.
func comeca_arremessar_bola(bola : Bola, alvo, tile_alvo : Vector2i):
	# Prepara a acao_atual para ser a ação de "ArremessarBola".
	acao_atual = acoes["ArremessarBola"]
	acao_atual.faze_de_preparacao([bola, alvo, tile_alvo])

# Muda para o estado Parado após o jogador arremessar a bola.
func fim_arremessar_bola():
	com_bola = false
	# Finaliza a acao_atual e muda ela para a ação "Parado".
	acao_atual.finalizacao()
	acao_atual = acoes["Parado"]

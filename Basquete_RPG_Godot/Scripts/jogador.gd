# -<jogador>-------------------------------------------------------------------------------------- #
# Jogador controlado pelo player, faz as ações no jogo.
# ------------------------------------------------------------------------------------------------ #
extends CharacterBody2D
class_name Jogador

@onready var ponto_bola = $PontoBola
@onready var status = $Status

var com_bola : bool = false
var time : TimeJogadores = null

#Ações
var acoes : Dictionary
var acao_atual : Acao = null
var numero_acoes : int
var numero_acoes_maximo : int = 3

signal acao_fim

func _ready():
	# Ações
	acao_atual = get_node("Acoes").get_primeira_acao()
	acoes = get_node("Acoes").get_acoes_dict()
	numero_acoes = numero_acoes_maximo
	# Conecta o sinal de fim.
	acoes["Mover"].fim.connect(fim_mover)
	acoes["PegarBola"].fim.connect(fim_pegar_bola)
	acoes["PassarBola"].fim.connect(fim_passar_bola)
	acoes["ArremessarBola"].fim.connect(fim_arremessar_bola)
	acoes["RoubarBola"].fim.connect(fim_roubar_bola)
	acoes["EnterrarBola"].fim.connect(fim_enterrar_bola)
	acoes["Descansar"].fim.connect(fim_descansar)

func _physics_process(delta):
	# Fica executando constantemente a ação atual.
	acao_atual.executando(delta)
# ------------------------------------------------------------------------------------------------ #

# ------------------------------------------------------------------------------------------------ #
# Funções variadas:
# Ajusta o jogador no tile em que ele está.
func Ajustar_no_tile():
	# Centraliza o jogador no tile.
	self.global_position = Global.quadra.cordenada_centralizada(self.global_position)
	# Deixa o tile que está como não navegavel.
	var tile = Global.quadra.cord_para_tile(self.global_position)
	Global.quadra.set_tile_nao_navegavel(tile)

# Retorna quanto de energia o jogador ganha por ação de descanso.
func ganho_de_energia():
	return status.get_energia_forca()
# ------------------------------------------------------------------------------------------------ #

# ------------------------------------------------------------------------------------------------ #
# Consegue fazer ações:
func consegue_mover_ou_descansar():
	return tem_acoes()

func consegue_passar_ou_arremessar():
	return (tem_acoes() and com_bola)

func consegue_enterrar():
	if tem_acoes() and com_bola:
		var tile = Global.quadra.cord_para_tile(self.global_position)
		# Verifica esquerda:
		var cords = Global.quadra.tile_para_cord(tile + Vector2i.LEFT)
		var alvo = Global.controlador.verifica_ponto(cords)
		if alvo is Cesta:
			return true
		# Verifica direita:
		cords = Global.quadra.tile_para_cord(tile + Vector2i.RIGHT)
		alvo = Global.controlador.verifica_ponto(cords)
		if alvo is Cesta:
			return true
		return false
	else:
		return false

func consegue_roubar():
	if tem_acoes():
		var tile = Global.quadra.cord_para_tile(self.global_position)
		var tiles_ao_redor = Global.quadra.area_quadrada(tile, 1)
		tiles_ao_redor.erase(tile)
		for t in tiles_ao_redor:
			var cordenada = Global.quadra.tile_para_cord(t)
			var alvo = Global.controlador.verifica_ponto(cordenada)
			# Se o jogador proximo estiver com a bola:
			if alvo is Jogador and alvo.com_bola:
				return true
		return false
	else:
		return false
# ------------------------------------------------------------------------------------------------ #

# ------------------------------------------------------------------------------------------------ #
# Set/Get:
func set_time(novo_time : TimeJogadores):
	time = novo_time

func get_time():
	return time
# ------------------------------------------------------------------------------------------------ #

# ------------------------------------------------------------------------------------------------ #
# Acontecimentos:
# Executada quando o jogador tiver a bola roubada dele.
func perdeu_bola():
	com_bola = false

func fica_atordoado():
	set_numero_acoes(0)
# ------------------------------------------------------------------------------------------------ #

# ------------------------------------------------------------------------------------------------ #
# Ações:
func set_numero_acoes(valor : int):
	numero_acoes = valor

func fez_acao():
	numero_acoes -= 1

func reset_numero_acoes():
	numero_acoes = numero_acoes_maximo

func get_acoes_disponiveis():
	return numero_acoes

func tem_acoes():
	return numero_acoes > 0

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
	if Global.controlador.jogador_em_bola(self):
		self.comeca_pegar_bola(Global.bola)
	else:
		Global.acao_acabou.emit()
	fez_acao()

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
	if not Global.controlador.jogador_no_time_do_turno(self):
		Global.finalizar_turno.emit()

# - PassarBola
# Começa a ação de PassarBola.
func comeca_passar_bola(bola : Bola, alvo, tile_alvo : Vector2i, forca : int):
	# Prepara a acao_atual para ser a ação de "PassarBola".
	acao_atual = acoes["PassarBola"]
	acao_atual.faze_de_preparacao([bola, alvo, tile_alvo, forca])

# Finaliza a ação PassarBola.
func fim_passar_bola():
	com_bola = false
	# Finaliza a acao_atual e muda ela para a ação "Parado".
	acao_atual.finalizacao()
	acao_atual = acoes["Parado"]
	fez_acao()

# - ArremessarBola
# Começa a ação de ArremessarBola.
func comeca_arremessar_bola(bola : Bola, alvo, tile_alvo : Vector2i, forca : int):
	# Prepara a acao_atual para ser a ação de "ArremessarBola".
	acao_atual = acoes["ArremessarBola"]
	acao_atual.faze_de_preparacao([bola, alvo, tile_alvo, forca])

# Finaliza a ação ArremessarBola.
func fim_arremessar_bola():
	com_bola = false
	# Finaliza a acao_atual e muda ela para a ação "Parado".
	acao_atual.finalizacao()
	acao_atual = acoes["Parado"]
	fez_acao()

# - RoubarBola
# Começa a ação de RoubarBola.
func comeca_roubar_bola(bola : Bola, alvo : Jogador, aliado : bool, dificuldade : int, forca : int):
	acao_atual = acoes["RoubarBola"]
	acao_atual.faze_de_preparacao([bola, alvo, aliado, dificuldade, forca])

# Finaliza a ação RoubarBola.
func fim_roubar_bola():
	# Finaliza a acao_atual e muda ela para a ação "Parado".
	acao_atual.finalizacao()
	acao_atual = acoes["Parado"]
	# Emite o sinal informando que a ação acabou.  
	Global.acao_acabou.emit()

# - EnterrarBola
# Começa a ação de EnterrarBola.
func comeca_enterrar_bola(bola : Bola, alvo : Cesta, dificuldade : int, forca : int):
	acao_atual = acoes["EnterrarBola"]
	acao_atual.faze_de_preparacao([bola, alvo, dificuldade, forca])

# Finaliza a ação EnterrarBola.
func fim_enterrar_bola():
	com_bola = false
	# Finaliza a acao_atual e muda ela para a ação "Parado".
	acao_atual.finalizacao()
	acao_atual = acoes["Parado"]
	fez_acao()

# - Descansar
# Começa a ação de Descansar.
func comeca_descansar(valor_descanso : int):
	acao_atual = acoes["Descansar"]
	acao_atual.faze_de_preparacao([valor_descanso, get_acoes_disponiveis()])

# Finaliza a ação de Descansar.
func fim_descansar():
	# Finaliza a acao_atual e muda ela para a ação "Parado".
	acao_atual.finalizacao()
	acao_atual = acoes["Parado"]
	Global.acao_acabou.emit()
	set_numero_acoes(0)
# ------------------------------------------------------------------------------------------------ #

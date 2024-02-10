# -<jogador>-------------------------------------------------------------------------------------- #
# Jogador controlado pelo player, faz as ações no jogo.
# ------------------------------------------------------------------------------------------------ #
extends CharacterBody2D
class_name Jogador

@onready var ponto_bola = $PontoBola
@onready var status = $Status
@onready var aparencia : Aparencia = $Aparencia

var com_bola : bool = false
var modo_defesa : bool = false
var pode_mover : bool = true
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
	acoes["Descansar"].fim.connect(fim_descansar)
	acoes["DefesaNoAr"].fim.connect(fim_defesa_no_ar)
	acoes["Bloquear"].fim.connect(fim_bloquear)

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
# ------------------------------------------------------------------------------------------------ #

# ------------------------------------------------------------------------------------------------ #
# Consegue fazer ações:
func consegue_mover():
	return (tem_acoes() and pode_mover)

func consegue_descansar():
	return tem_acoes()

func consegue_passar_ou_arremessar():
	return (tem_acoes() and com_bola)

func consegue_defender():
	return (tem_acoes() and not com_bola)

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

func set_pode_mover(valor : bool):
	pode_mover = valor

func get_pode_mover():
	return pode_mover

func get_modo_defesa():
	return modo_defesa
# ------------------------------------------------------------------------------------------------ #

# ------------------------------------------------------------------------------------------------ #
# Acontecimentos:
# Executada quando o jogador tiver a bola roubada dele.
func perdeu_bola():
	com_bola = false

func fica_atordoado():
	set_numero_acoes(0)

func foi_bloqueado():
	set_pode_mover(false)

func entra_modo_defesa():
	self.modo_defesa = true
	set_numero_acoes(0)

func sai_modo_defesa():
	self.modo_defesa = false

func perdeu_na_defesa():
	self.modo_defesa = false
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
	if pode_mover:
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
	set_pode_mover(true)
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
	set_pode_mover(true)
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

# - DefesaNoAr
func comeca_defesa_no_ar(alvo : Bola, dificuldade : int, forca : int):
	acao_atual = acoes["DefesaNoAr"]
	acao_atual.faze_de_preparacao([alvo, dificuldade, forca])

func fim_defesa_no_ar():
	# Finaliza a acao_atual e muda ela para a ação "Parado".
	acao_atual.finalizacao()
	acao_atual = acoes["Parado"]

# - Bloquear
func comeca_bloquear(alvo : Jogador, dificuldade : int, forca : int):
	acao_atual = acoes["Bloquear"]
	acao_atual.faze_de_preparacao([alvo, dificuldade, forca])

func fim_bloquear():
	# Finaliza a acao_atual e muda ela para a ação "Parado".
	acao_atual.finalizacao()
	acao_atual = acoes["Parado"]
# ------------------------------------------------------------------------------------------------ #

# ------------------------------------------------------------------------------------------------ #
# Aparencia
func set_contorno(valor : bool, cor : Color = Color(1, 1, 1, 1)):
	if valor:
		aparencia.bota_contorno(cor)
	else:
		aparencia.tira_contorno()

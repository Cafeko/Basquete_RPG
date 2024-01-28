# -<ui>------------------------------------------------------------------------------------------- #
# Gerencia a interface de usuario.
# ------------------------------------------------------------------------------------------------ #
extends CanvasLayer

@onready var menu_acoes = $MenuAcoes
@onready var confirmacao = $Confirmacao
@onready var fim_turno = $FimTurno
@onready var barra_forca = $BarraForca
@onready var barra_forca_botao = $BarraForca/Botao
@onready var valores = $Valores
@onready var valor_esq = $Valores/HBoxContainer/Valor1
@onready var valor_dir = $Valores/HBoxContainer/Valor2
@onready var status_jogador = $StatusJogador

# Botoes do menu de ações:
@onready var botao_mover = $MenuAcoes/ColorRect/HBoxContainer/Botoes/BotaoMover
@onready var botao_passar_bola = $MenuAcoes/ColorRect/HBoxContainer/Botoes/BotaoPassarBola
@onready var botao_arremessar_bola = $MenuAcoes/ColorRect/HBoxContainer/Botoes/BotaoArremessarBola
@onready var botao_enterrar_bola = $MenuAcoes/ColorRect/HBoxContainer/Botoes/BotaoEnterrarBola
@onready var botao_roubar_bola = $MenuAcoes/ColorRect/HBoxContainer/Botoes/BotaoRoubarBola
@onready var botao_descanso = $MenuAcoes/ColorRect/HBoxContainer/Botoes/BotaoDescanso

# Status:
@onready var status_nomes = $StatusJogador/Control/ColorRect/HBoxContainer/HBoxContainer/LabelsNome
@onready var status_valores = $StatusJogador/Control/ColorRect/HBoxContainer/HBoxContainer/LabelsValores
@onready var status_acoes_nome = $StatusJogador/Control/ColorRect/HBoxContainer/AcoesNumero/HBoxContainer/Acoes
@onready var status_acoes_valor = $StatusJogador/Control/ColorRect/HBoxContainer/AcoesNumero/HBoxContainer/Label8
var status_index_dict : Dictionary = {}
var status_nomes_lista : Array = []
var status_valores_lista : Array = []

var valor_jogador : String
var valor_adversario : String

func _ready():
	Global.ui = self
	esconde_menu_acoes()
	esconde_confirmacao()
	esconde_fim_turno()
	esconde_barra_forca()
	reset_valores()
	esconde_valores()
	esconde_status_jogador()
	prepara_status()
# ------------------------------------------------------------------------------------------------ #

# ------------------------------------------------------------------------------------------------ #
# - Exibe/Esconde:
func exibe_menu_acoes():
	menu_acoes.visible = true

func esconde_menu_acoes():
	menu_acoes.visible = false

func exibe_confirmacao():
	confirmacao.visible = true

func esconde_confirmacao():
	confirmacao.visible = false

func exibe_fim_turno():
	fim_turno.visible = true

func esconde_fim_turno():
	fim_turno.visible = false

func exibe_barra_forca():
	barra_forca.visible = true
	exibe_barra_forca_botao()

func esconde_barra_forca():
	barra_forca.visible = false
	esconde_barra_forca_botao()

func exibe_barra_forca_botao():
	barra_forca_botao.visible = true

func esconde_barra_forca_botao():
	barra_forca_botao.visible = false

func exibe_valores():
	valores.visible = true

func esconde_valores():
	valores.visible = false

func exibe_status_jogador():
	status_jogador.visible = true

func esconde_status_jogador():
	status_jogador.visible = false
# ------------------------------------------------------------------------------------------------ #

# ------------------------------------------------------------------------------------------------ #
# - Menu Ações
func abre_menu_acoes():
	exibe_menu_acoes()
	verifica_botoes_disponiveis()
	pass

func fecha_menu_acoes():
	esconde_menu_acoes()

func desabilita_botoes():
	botao_mover.disabled = true
	botao_passar_bola.disabled = true
	botao_arremessar_bola.disabled = true
	botao_enterrar_bola.disabled = true
	botao_roubar_bola.disabled = true
	botao_descanso.disabled = true

func verifica_botoes_disponiveis():
	desabilita_botoes()
	var jogador : Jogador = Global.controlador.get_jogador_selecionado()
	if jogador == null:
		return
	# Botão Mover:
	botao_mover.disabled = !(jogador.consegue_mover_ou_descansar())
	# Botão Passar Bola:
	botao_passar_bola.disabled = !(jogador.consegue_passar_ou_arremessar())
	# Botão Arremessar Bola:
	botao_arremessar_bola.disabled = !(jogador.consegue_passar_ou_arremessar())
	# Botão Enterrar Bola:
	botao_enterrar_bola.disabled = !(jogador.consegue_enterrar())
	# Botão Roubar Bola:
	botao_roubar_bola.disabled = !(jogador.consegue_roubar())
	# Botão Descanso:
	botao_descanso.disabled = !(jogador.consegue_mover_ou_descansar())
# ------------------------------------------------------------------------------------------------ #

# ------------------------------------------------------------------------------------------------ #
# - Status
func abre_status_jogador():
	exibe_status_jogador()
	set_valores_do_jogador()
	pass

func fecha_status_jogador():
	esconde_status_jogador()

func prepara_status():
	# Prepara a lista nós de nomes dos status e o dicionario de indices.
	var x = 0
	for status in status_nomes.get_children():
		status_nomes_lista.append(status)
		var nome = status.name
		status_index_dict[nome] = x
		x += 1
	status_nomes_lista.append(status_acoes_nome)
	status_index_dict["Acoes"] = x
	# Prepara a lista de nós valores dos status.
	for label in status_valores.get_children():
		status_valores_lista.append(label)
	status_valores_lista.append(status_acoes_valor)

func set_valores_do_jogador():
	var jogador : Jogador = Global.controlador.get_jogador_selecionado()
	if jogador == null:
		return
	# Passe:
	var indice = status_index_dict["Passe"]
	var valor = jogador.status.get_passe_forca()
	status_valores_lista[indice].text = str(valor)
	# Arremesso:
	indice = status_index_dict["Arremesso"]
	valor = jogador.status.get_arremesso_forca()
	status_valores_lista[indice].text = str(valor)
	# Ataque:
	indice = status_index_dict["Ataque"]
	valor = jogador.status.get_ataque_forca()
	status_valores_lista[indice].text = str(valor)
	# Defesa:
	indice = status_index_dict["Defesa"]
	valor = jogador.status.get_defesa_forca()
	status_valores_lista[indice].text = str(valor)
	# Bloqueio:
	indice = status_index_dict["Bloqueio"]
	valor = jogador.status.get_bloqueio_forca()
	status_valores_lista[indice].text = str(valor)
	# NoAr:
	indice = status_index_dict["NoAr"]
	valor = jogador.status.get_no_ar_forca()
	status_valores_lista[indice].text = str(valor)
	# Energia:
	indice = status_index_dict["Energia"]
	valor = jogador.status.get_energia()
	status_valores_lista[indice].text = str(valor)
	# Ações:
	indice = status_index_dict["Acoes"]
	valor = jogador.get_acoes_disponiveis()
	status_valores_lista[indice].text = str(valor)
# ------------------------------------------------------------------------------------------------ #

# ------------------------------------------------------------------------------------------------ #
# - Valores
func reset_valores():
	valor_esq.text = ""
	valor_dir.text = ""
	valor_jogador = ""
	valor_adversario = ""

func set_valor_jogador(texto : String):
	valor_jogador = texto

func set_valor_adversario(texto : String):
	valor_adversario = texto

func atualiza_valores(jogador_na_esquerda : bool = true):
	if jogador_na_esquerda:
		valor_esq.text = valor_jogador
		valor_dir.text = valor_adversario
	else:
		valor_esq.text = valor_adversario
		valor_dir.text = valor_jogador
# ------------------------------------------------------------------------------------------------ #

# ------------------------------------------------------------------------------------------------ #
func mouse_entrou():
	Global.controlador.set_mouse_em_botao(true)

func mouse_saiu():
	Global.controlador.set_mouse_em_botao(false)

func on_botao_mover():
	Global.acao_escolhida.emit("Mover")

func on_botao_passar_bola():
	Global.acao_escolhida.emit("PassarBola")

func on_botao_arremessar_bola():
	Global.acao_escolhida.emit("ArremessarBola")

func on_botao_confirmar():
	Global.confirmar_acao.emit(Global.controlador_estado_atual)

func on_botao_cancelar():
	Global.cancelar_acao.emit(Global.controlador_estado_atual)

func on_botao_fim_turno():
	Global.finalizar_turno.emit()

func on_botao_para_barra():
	Global.para_barra_forca.emit()

func on_botao_roubar_bola():
	Global.acao_escolhida.emit("RoubarBola")

func on_botao_enterrar_bola():
	Global.acao_escolhida.emit("Enterrar")

func on_botao_descanso():
	Global.acao_escolhida.emit("Descansar")

func on_botao_fechar():
	Global.acao_escolhida.emit("FecharMenu")

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

# Botoes do menu de ações:
@onready var botao_mover = $MenuAcoes/ColorRect/HBoxContainer/Botoes/BotaoMover
@onready var botao_passar_bola = $MenuAcoes/ColorRect/HBoxContainer/Botoes/BotaoPassarBola
@onready var botao_arremessar_bola = $MenuAcoes/ColorRect/HBoxContainer/Botoes/BotaoArremessarBola
@onready var botao_enterrar_bola = $MenuAcoes/ColorRect/HBoxContainer/Botoes/BotaoEnterrarBola
@onready var botao_roubar_bola = $MenuAcoes/ColorRect/HBoxContainer/Botoes/BotaoRoubarBola
@onready var botao_descanso = $MenuAcoes/ColorRect/HBoxContainer/Botoes/BotaoDescanso


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
# ------------------------------------------------------------------------------------------------ #

# ------------------------------------------------------------------------------------------------ #
# - Exibe/Esconde botões:
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
	pass
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

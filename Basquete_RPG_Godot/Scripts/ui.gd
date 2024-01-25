# -<ui>------------------------------------------------------------------------------------------- #
# Gerencia a interface de usuario.
# ------------------------------------------------------------------------------------------------ #
extends CanvasLayer

@onready var menu_acoes = $MenuAcoes
@onready var confirmacao = $Confirmacao
@onready var fim_turno = $FimTurno
@onready var barra_forca = $BarraForca
@onready var barra_forca_botao = $BarraForca/Botao

func _ready():
	Global.ui = self
	esconde_menu_acoes()
	esconde_confirmacao()
	esconde_fim_turno()
	esconde_barra_forca()
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

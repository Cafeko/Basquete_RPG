# -<ui>------------------------------------------------------------------------------------------- #
# Gerencia a interface de usuario.
# ------------------------------------------------------------------------------------------------ #
extends Control

func _ready():
	Global.ui = self
	visible = false

func on_botao_mover():
	Global.acao_escolhida.emit("Mover")

func on_botao_pegar_bola():
	Global.acao_escolhida.emit("PegarBola")

func on_botao_passar_bola():
	Global.acao_escolhida.emit("PassarBola")

func on_botao_arremessar_bola():
	Global.acao_escolhida.emit("ArremessarBola")

extends Control

func _ready():
	Global.ui = self
	visible = false

func on_button_up():
	Global.controlador.estado_atual = Global.controlador.estados.MOVER_JOGADOR

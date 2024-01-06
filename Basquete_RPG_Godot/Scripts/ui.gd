# -<ui>------------------------------------------------------------------------------------------- #
# Gerencia a interface de usuario.
# ------------------------------------------------------------------------------------------------ #
extends Control

func _ready():
	Global.ui = self
	visible = false

# Quando o botão for precionado muda o estado para a ação relacionada a esse botão.
func on_button_up():
	Global.acao_escolhida.emit("Mover")

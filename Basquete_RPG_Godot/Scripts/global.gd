# -<global>--------------------------------------------------------------------------------------- #
# Pode ser acessado por qualquer script, deixa mais facil de pegar a referencia de um script,
# facilitando na comunicação entre eles. 
# ------------------------------------------------------------------------------------------------ #
extends Node

var controlador
var quadra : Quadra
var ui
var bola : Bola
var visual

# Sinais:
signal acao_escolhida
signal acao_acabou
signal pegou_bola
signal passou_bola
signal arremessou_bola

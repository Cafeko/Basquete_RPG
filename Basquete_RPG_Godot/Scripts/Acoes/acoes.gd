# -<acoes>---------------------------------------------------------------------------------------- #
# Nó que contem as ações, guardando elas em um dicionario.
# ------------------------------------------------------------------------------------------------ #
extends Node

@export var primeira_acao : Acao

var acoes_dict : Dictionary

func _ready():
	# Pega todos os filhos que são "Acao" e coloca eles em um dicionario onde a chave é seu nome.
	for acao in get_children():
		if acao is Acao:
			var nome = acao.name
			acoes_dict[nome] = acao

func get_primeira_acao():
	return primeira_acao

func get_acoes_dict():
	return acoes_dict

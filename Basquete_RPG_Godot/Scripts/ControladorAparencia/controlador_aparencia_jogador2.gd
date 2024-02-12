# -<controlador_aparencia_jogador2>--------------------------------------------------------------- #
# Controlador de aparencia do jogador2.
# ------------------------------------------------------------------------------------------------ #
extends Aparencia

var direcao : Vector2i = Vector2i.DOWN
var tem_bola : bool = false

func toca_animacao(animacao_nome : String):
	if animacao_nome == "Parado":
		animacao_parado("Parado")
	elif animacao_nome == "Movendo":
		animacao_movendo("Movendo")
	elif animacao_nome == "Pega":
		animacao_receber("Receber")

func animacao_parado(nome_animacao : String):
	if direcao.x != 0:
		pai.scale.x = direcao.x
	if direcao.y < 0:
		nome_animacao = nome_animacao + "_Cima"
	elif direcao.y > 0:
		nome_animacao = nome_animacao + "_Baixo"
	if tem_bola:
		nome_animacao = nome_animacao + "_Bola"
	animacao.play(nome_animacao)

func animacao_movendo(nome_animacao : String):
	if direcao.x != 0:
		nome_animacao = nome_animacao + "_Lado"
		pai.scale.x = direcao.x
	elif direcao.y < 0:
		nome_animacao = nome_animacao + "_Cima"
	elif direcao.y > 0:
		nome_animacao = nome_animacao + "_Baixo"
	if tem_bola:
		nome_animacao = nome_animacao + "_Bola"
	animacao.play(nome_animacao)

func animacao_receber(nome_animacao : String):
	if direcao.x != 0:
		nome_animacao = nome_animacao + "_Lado"
		pai.scale.x = direcao.x
	if direcao.y < 0:
		nome_animacao = nome_animacao + "_Cima"
	elif direcao.y > 0:
		nome_animacao = nome_animacao + "_Baixo"
	if tem_bola:
		nome_animacao = nome_animacao + "_Bola"
	animacao.play(nome_animacao)

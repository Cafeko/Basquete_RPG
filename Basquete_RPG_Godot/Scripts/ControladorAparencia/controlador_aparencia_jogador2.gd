# -<controlador_aparencia_jogador2>--------------------------------------------------------------- #
# Controlador de aparencia do jogador2.
# ------------------------------------------------------------------------------------------------ #
extends Aparencia

var direcao : Vector2i = Vector2i.DOWN
var tem_bola : bool = false
var porsentagem_diferenca = 0.25
var animacao_atual : String

func atualiza_animacao():
	var partes = animacao_atual.split("_")
	toca_animacao(partes[0])

func toca_animacao(animacao_nome : String):
	if animacao_nome == "Parado":
		animacao_parado("Parado")
	elif animacao_nome == "Movendo":
		animacao_movendo("Movendo")
	elif animacao_nome == "Receber":
		animacao_receber("Receber")
	elif animacao_nome == "Passe":
		animacao_jogar_bola("Passe")
	elif animacao_nome == "Arremesso":
		animacao_jogar_bola("Arremesso")

func animacao_parado(nome_animacao : String):
	direcao_x()
	if direcao.y < 0:
		nome_animacao = nome_animacao + "_Cima"
	else:
		nome_animacao = nome_animacao + "_Baixo"
	if tem_bola:
		nome_animacao = nome_animacao + "_Bola"
	animacao_atual = nome_animacao
	animacao.play(nome_animacao)

func animacao_movendo(nome_animacao : String):
	direcao_x()
	if direcao.x != 0:
		nome_animacao = nome_animacao + "_Lado"
	elif direcao.y < 0:
		nome_animacao = nome_animacao + "_Cima"
	elif direcao.y > 0:
		nome_animacao = nome_animacao + "_Baixo"
	if tem_bola:
		nome_animacao = nome_animacao + "_Bola"
	animacao_atual = nome_animacao
	animacao.play(nome_animacao)

func animacao_receber(nome_animacao : String):
	nome_animacao = direcao_dinamica(nome_animacao)
	if tem_bola:
		nome_animacao = nome_animacao + "_Bola"
	animacao_atual = nome_animacao
	animacao.play(nome_animacao)

func animacao_jogar_bola(nome_animacao : String):
	nome_animacao = direcao_dinamica(nome_animacao)
	animacao_atual = nome_animacao
	animacao.play(nome_animacao)

func direcao_x():
	if direcao.x > 0:
		pai.scale.x = 1
	elif direcao.x < 0:
		pai.scale.x = -1

func direcao_dinamica(nome_animacao : String):
	direcao_x()
	var x_abs = abs(direcao.x)
	var y_abs = abs(direcao.y)
	var total = x_abs + y_abs
	if x_abs >= y_abs:
		nome_animacao = nome_animacao + "_Lado"
		if y_abs >= (total * porsentagem_diferenca):
			if direcao.y < 0:
				nome_animacao = nome_animacao + "_Cima"
			elif direcao.y > 0:
				nome_animacao = nome_animacao + "_Baixo"
	else:
		if x_abs >= (total * porsentagem_diferenca):
			nome_animacao = nome_animacao + "_Lado"
		if direcao.y < 0:
			nome_animacao = nome_animacao + "_Cima"
		elif direcao.y > 0:
			nome_animacao = nome_animacao + "_Baixo"
	return nome_animacao

func on_animation_finished(anim_name):
	if "Passe" in anim_name:
		Global.animacao_fim_passe.emit(pai)
	elif "Arremesso" in anim_name:
		Global.animacao_fim_arremesso.emit(pai)

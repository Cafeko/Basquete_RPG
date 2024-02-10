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
var controlador_estado_atual : String
var barra_forca

# Sinais:
signal acao_escolhida
signal acao_acabou
signal pegou_bola
signal passou_bola
signal arremessou_bola
signal confirmar_acao
signal cancelar_acao
signal acertou_cesta
signal errou_cesta
signal finalizar_turno
signal para_barra_forca
signal roubou_bola
signal entrou_botao_menu
signal saiu_botao_menu
signal teve_interrupcao
signal defesa_deu_errado
signal defesa_deu_certo
signal para_movimento_bola
signal continua_movimento_bola
signal para_bola_no_ar
signal finaliza_movimento_jogador
signal continua_movimento_jogador
signal fez_ponto

# -<ucontrolador>--------------------------------------------------------------------------------- #
# Gerencia os estados do jogo e trata os inputs do usuario.
# ------------------------------------------------------------------------------------------------ #
extends Node2D

@onready var maquina_estados = $MaquinaEstados

var jogador_selecionado = null

signal acabou_acao

func _ready():
	Global.controlador = self
	maquina_estados.executar_controlador_pronto()

# Verifica se em um ponto/cordenada especifica tem algum corpo, o retornando se sim.
func verifica_ponto(ponto : Vector2):
	var space = get_world_2d().direct_space_state
	var ponto_fisico : PhysicsPointQueryParameters2D = PhysicsPointQueryParameters2D.new()
	ponto_fisico.position = ponto
	ponto_fisico.set_collide_with_bodies(true)
	var resultado = space.intersect_point(ponto_fisico, 1)
	if resultado != []:
		return resultado[0]["collider"]
	else:
		return null

func set_jogador_selecionado(jogador : Jogador):
	jogador_selecionado = jogador

func get_jogador_selecionado():
	return jogador_selecionado

func conectar_acao_fim():
	jogador_selecionado.acao_fim.connect(on_acao_fim)

# Quando receber um sinal de que a ação acabou: desconecta o sinal e muda o estado atual.
func on_acao_fim():
	jogador_selecionado.acao_fim.disconnect(on_acao_fim)
	acabou_acao.emit()

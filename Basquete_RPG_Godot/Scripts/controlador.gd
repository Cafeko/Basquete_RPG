extends Node2D

var estado_atual : int
var jogador_selecionado = null

enum estados{SELECIONAR_JOGADOR, ESCOLHE_ACAO, MOVER_JOGADOR, ESPERA_ACAO}

func _ready():
	Global.controlador = self
	estado_atual = estados.SELECIONAR_JOGADOR

func _physics_process(_delta):
	match estado_atual:
		estados.SELECIONAR_JOGADOR:
			estado_seleciona_jogador()
		estados.ESCOLHE_ACAO:
			estado_escolhe_acao()
		estados.MOVER_JOGADOR:
			estado_mover_jogador()
		estados.ESPERA_ACAO:
			pass

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

func estado_seleciona_jogador():
	if Input.is_action_just_pressed("mouse_esq"):
		var posicao_mouse = get_global_mouse_position()
		jogador_selecionado = verifica_ponto(posicao_mouse)
		if jogador_selecionado != null:
			estado_atual = estados.ESCOLHE_ACAO

func estado_escolhe_acao():
	Global.ui.visible = true

func estado_mover_jogador():
	Global.ui.visible = false
	if Input.is_action_just_pressed("mouse_esq"):
		var posicao_mouse = get_global_mouse_position()
		var caminho = Global.quadra.cria_caminho(jogador_selecionado.global_position, posicao_mouse)
		jogador_selecionado.acao_fim.connect(on_acao_fim)
		jogador_selecionado.comeca_mover(caminho)
		estado_atual = estados.ESPERA_ACAO

func on_acao_fim():
	jogador_selecionado.acao_fim.disconnect(on_acao_fim)
	estado_atual = estados.SELECIONAR_JOGADOR

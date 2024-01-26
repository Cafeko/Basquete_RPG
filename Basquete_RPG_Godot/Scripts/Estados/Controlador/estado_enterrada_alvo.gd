# -<estado_enterrada_alvo>------------------------------------------------------------------------ #
# Estado do controlador, estado onde é definido o alvo da enterrada e sua dificuldade.
# ------------------------------------------------------------------------------------------------ #
extends Estado

var jogador : Jogador
var tile_jogador : Vector2i
var alcance_enterrada : int = 1
var cesta : Cesta
var jogadores_proximos : Array
var dificuldade : int
var primeira : bool = true

# Executada quando os nós estiverem prontos.
func tudo_pronto():
	Global.confirmar_acao.connect(on_confirmar_acao)
	Global.cancelar_acao.connect(on_cancelar_acao)

# Executado quando entra no estado.
func entrando():
	primeira = true
	cesta = null
	jogadores_proximos = []
	dificuldade = 0
	jogador = Global.controlador.get_jogador_selecionado()
	tile_jogador = Global.quadra.cord_para_tile(jogador.global_position)
	verifica_proximidades(tile_jogador)

# Executando enquanto está no estado.
func executando(_delta):
	if primeira:
		if cesta != null and jogador.com_bola:
			# Define a dificuldade somando a dificuldade pela distancia a defesa no ar dos
			# adversarios que estão em cima e em baixo.
			dificuldade = cesta.define_dificuldade(tile_jogador)
			for j in jogadores_proximos:
				dificuldade += j.status.defesa_no_ar()
			Global.ui.exibe_confirmacao()
		else:
			muda_estado.emit(self.name, "SelecionaJogador")
		primeira = false

# Executado ao sair do estado
func saindo():
	Global.ui.esconde_confirmacao()

# Verifica os tiles proximos
func verifica_proximidades(tile):
	var alvo
	# - Cesta
	# Verifica esquerda:
	var cords = Global.quadra.tile_para_cord(tile + Vector2i.LEFT)
	alvo = Global.controlador.verifica_ponto(cords)
	if alvo is Cesta:
		cesta = alvo
	# Verifica direita:
	cords = Global.quadra.tile_para_cord(tile + Vector2i.RIGHT)
	alvo = Global.controlador.verifica_ponto(cords)
	if alvo is Cesta:
		cesta = alvo
	# - Adversarios
	# Verifica Cima:
	cords = Global.quadra.tile_para_cord(tile + Vector2i.UP)
	alvo = Global.controlador.verifica_ponto(cords)
	if alvo is Jogador and not Global.controlador.jogador_no_time_do_turno(alvo):
		jogadores_proximos.append(alvo)
	# Verifica Baixo:
	cords = Global.quadra.tile_para_cord(tile + Vector2i.DOWN)
	alvo = Global.controlador.verifica_ponto(cords)
	if alvo is Jogador and not Global.controlador.jogador_no_time_do_turno(alvo):
		jogadores_proximos.append(alvo)
	
func on_confirmar_acao(estado_alvo : String):
	if self.name == estado_alvo:
		Global.controlador.add_info("EnterraBola")
		Global.ui.set_valor_adversario(str(dificuldade))
		Global.controlador.add_info([Global.bola, cesta, dificuldade])
		muda_estado.emit(self.name, "DefinaForcaAcao")

func on_cancelar_acao(estado_alvo : String):
	if self.name == estado_alvo:
		muda_estado.emit(self.name, "SelecionaJogador")

# -<estado_com_jogador>--------------------------------------------------------------------------- #
# Estado da bola, faz a bola se mover com o jogador que estiver com ela.
# ------------------------------------------------------------------------------------------------ #
extends Estado

@export var bola : Bola

var jogador : Jogador
var roubada : bool = false
var tile_atual : Vector2i

# Executada quando os nós estiverem prontos.
func tudo_pronto():
	Global.passou_bola.connect(on_passou_bola)
	Global.arremessou_bola.connect(on_arremessou_bola)
	Global.roubou_bola.connect(on_roubou_bola)
	Global.enterrou_bola.connect(on_enterrou_bola)

# Executado quando entra no estado.
func entrando():
	roubada = false
	jogador = bola.get_jogador_segurando()

# Executando enquanto está no estado.
func executando(_delta):
	bola.global_position = jogador.ponto_bola.global_position

# Executado ao sair do estado
func saindo():
	if not roubada:
		bola.set_jogador_segurando(null)

func on_passou_bola():
	muda_estado.emit(self.name, "EmPasse")

func on_arremessou_bola():
	muda_estado.emit(self.name, "EmArremesso")

func on_roubou_bola(jogador_que_roubou):
	if jogador_que_roubou is Jogador:
		roubada = true
		bola.set_jogador_segurando(jogador_que_roubou)
		muda_estado.emit(self.name, "ComJogador")

func on_enterrou_bola():
	muda_estado.emit(self.name, "Enterrada")

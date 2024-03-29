# -<estado_parada>-------------------------------------------------------------------------------- #
# Estado da bola, estado em que a bola está parada.
# ------------------------------------------------------------------------------------------------ #
extends Estado

@export var bola : Bola

# Executada quando os nós estiverem prontos.
func tudo_pronto():
	Global.pegou_bola.connect(on_pegou_bola)
	Global.acertou_cesta.connect(on_acertou_cesta)
	Global.errou_cesta.connect(on_errou_cesta)
	Global.bola_move_para.connect(on_bola_move_para)

# Executado quando entra no estado.
func entrando():
	bola.aparencia.set_visivel(true)
	bola.set_jogador_segurando(null)

func on_pegou_bola(jogador):
	if jogador is Jogador:
		bola.set_jogador_segurando(jogador)
		muda_estado.emit(self.name, "ComJogador")

func on_errou_cesta(tile : Vector2i):
	bola.set_tile_alvo(tile)
	muda_estado.emit(self.name, "EmRebateu")

func on_acertou_cesta(tile : Vector2i):
	bola.set_tile_alvo(tile)
	muda_estado.emit(self.name, "MovePara")

func on_bola_move_para(tile : Vector2):
	bola.move_para_em_tile = false
	bola.set_tile_alvo(tile)
	muda_estado.emit(self.name, "MovePara")

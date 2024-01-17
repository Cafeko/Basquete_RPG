# -<estado_com_jogador>--------------------------------------------------------------------------- #
# Estado da bola, faz a bola se mover com o jogador que estiver com ela.
# ------------------------------------------------------------------------------------------------ #
extends Estado

@export var bola : Bola

var jogador : Jogador

# Executada quando os nós estiverem prontos.
func tudo_pronto():
	Global.passou_bola.connect(on_passou_bola)
	Global.arremessou_bola.connect(on_arremessou_bola)

# Executado quando entra no estado.
func entrando():
	jogador = bola.get_jogador_segurando()

# Executando enquanto está no estado.
func executando(_delta):
	bola.global_position = jogador.ponto_bola.global_position

# Executado ao sair do estado
func saindo():
	bola.set_jogador_segurando(null)

func on_passou_bola():
	muda_estado.emit(self.name, "EmPasse")

func on_arremessou_bola():
	muda_estado.emit(self.name, "EmArremesso")

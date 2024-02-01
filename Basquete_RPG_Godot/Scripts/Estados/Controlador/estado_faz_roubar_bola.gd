# -<estado_faz_roubar_bola>----------------------------------------------------------------------- #
# Estado do controlador, estado que faz o jogador fazer o roubo da bola com as informações
# perviamente definidas.
# ------------------------------------------------------------------------------------------------ #
extends Estado

var informacoes : Array
var jogador : Jogador
var bola : Bola
var alvo 
var aliado : bool
var dificuldade : int
var forca : int

# Executado quando entra no estado.
func entrando():
	informacoes = Global.controlador.get_info()
	jogador = Global.controlador.get_jogador_selecionado()
	bola = informacoes[1]
	alvo = informacoes[2]
	aliado = informacoes[3]
	dificuldade = informacoes [4]
	forca = informacoes[5]

# Executando enquanto está no estado.
func executando(_delta):
	jogador.comeca_roubar_bola(bola, alvo, aliado, dificuldade, forca)
	muda_estado.emit(self.name, "FazendoAcao")

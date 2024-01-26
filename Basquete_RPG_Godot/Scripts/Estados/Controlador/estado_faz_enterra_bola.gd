# -<estado_faz_roubar_bola>----------------------------------------------------------------------- #
# Estado do controlador, estado que faz o jogador fazer a enterrada com as informações já definidas.
# ------------------------------------------------------------------------------------------------ #
extends Estado

var informacoes : Array
var jogador : Jogador
var bola : Bola
var alvo 
var dificuldade : int
var forca : int

# Executado quando entra no estado.
func entrando():
	informacoes = Global.controlador.get_info()
	jogador = Global.controlador.get_jogador_selecionado()
	bola = informacoes[1]
	alvo = informacoes[2]
	dificuldade = informacoes [3]
	forca = informacoes[4]

# Executando enquanto está no estado.
func executando(_delta):
	jogador.comeca_enterrar_bola(bola, alvo, dificuldade, forca)
	muda_estado.emit(self.name, "FazendoAcao")

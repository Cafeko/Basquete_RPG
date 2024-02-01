# -<estado_faz_passe>----------------------------------------------------------------------------- #
# Estado do controlador, estado que faz o jogador fazer o passe com as informações já definidas.
# ------------------------------------------------------------------------------------------------ #
extends Estado

var informacoes : Array
var jogador : Jogador
var bola : Bola
var alvo 
var tile_alvo
var forca : int

# Executado quando entra no estado.
func entrando():
	informacoes = Global.controlador.get_info()
	jogador = Global.controlador.get_jogador_selecionado()
	bola = informacoes[1]
	alvo = informacoes[2]
	tile_alvo = informacoes[3]
	forca = informacoes[4]

# Executando enquanto está no estado.
func executando(_delta):
	jogador.comeca_passar_bola(bola, alvo, tile_alvo, forca)
	muda_estado.emit(self.name, "FazendoAcao")
	

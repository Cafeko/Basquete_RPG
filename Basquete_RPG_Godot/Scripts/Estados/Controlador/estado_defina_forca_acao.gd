# -<estado_defina_forca_acao>--------------------------------------------------------------------- #
# Estado do controlador, estado em é definida a força da ação.
# ------------------------------------------------------------------------------------------------ #
extends Estado

var informacoes : Array
var acao : String
var jogador : Jogador

# Executado quando entra no estado.
func entrando():
	informacoes = Global.controlador.get_info()
	acao = informacoes[0]
	jogador = Global.controlador.get_jogador_selecionado()

# Executando enquanto está no estado.
func executando(_delta):
	if acao == "Passe":
		var forca = jogador.status.get_passe_forca()
		Global.controlador.add_info(forca)
		muda_estado.emit(self.name, "FazPasse")
	elif acao == "Arremesso":
		var forca = jogador.status.get_arremesso_forca()
		Global.controlador.add_info(forca)
		muda_estado.emit(self.name, "FazArremesso")

# Executado ao sair do estado
func saindo():
	pass

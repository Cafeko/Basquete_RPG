# -<estado_defina_forca_acao>--------------------------------------------------------------------- #
# Estado do controlador, estado em é definida a força da ação.
# ------------------------------------------------------------------------------------------------ #
extends Estado

var informacoes : Array
var acao : String
var jogador : Jogador
var time_jogado_esquerda : bool
var na_esq : bool

# Executada quando os nós estiverem prontos.
func tudo_pronto():
	Global.para_barra_forca.connect(on_para_barra_forca)

# Executado quando entra no estado.
func entrando():
	# Valores:
	informacoes = Global.controlador.get_info()
	acao = informacoes[0]
	jogador = Global.controlador.get_jogador_selecionado()
	# Barra de força:
	Global.barra_forca.reset_barra_forca()
	Global.ui.exibe_barra_forca()
	Global.barra_forca.comeca_mover()
	# Exibe Valores:
	Global.ui.exibe_valores()
	na_esq = Global.controlador.time_na_esquerda(jogador.get_time())
	Global.ui.set_valor_jogador("00")
	Global.ui.atualiza_valores(na_esq)

# Executado ao sair do estado
func saindo():
	# Esconder barra de força e valores.
	Global.ui.esconde_barra_forca()
	Global.ui.esconde_valores()
	Global.ui.reset_valores()
	Global.controlador.set_contorno_times(false)
	Global.controlador.set_contorno_cestas(false)

func on_para_barra_forca():
	# Esconde o botão que para a barra de força.
	Global.ui.esconde_barra_forca_botao()
	# Para a barra de força e pega a potencia baseado onde a barra parou.
	Global.barra_forca.parar_mover()
	var potencia = Global.barra_forca.get_potencia_atual()
	# Pega a força_maxima da ação e o proximo estado, baseado na ação que está sendo feita.
	var lista = forca_e_acao()
	var forca_base : float = lista[0]
	var proximo_estado : String = lista[1]
	# Define a força, baseado na potencia adquirida, e a adiciona na lista de informações.
	var forca = round(forca_base * potencia)
	if forca <= 0:
		forca = 1
	Global.controlador.add_info(forca)
	Global.ui.set_valor_jogador(str(forca))
	Global.ui.atualiza_valores(na_esq)
	Global.ui.set_cor_do_valor(Global.barra_forca.get_cor_area_atual(), na_esq)
	# Espera 1 segundo pra ir para o proximo estado.
	await get_tree().create_timer(1.2).timeout
	muda_estado.emit(self.name, proximo_estado)

func forca_e_acao():
	var forca : float = 0
	var estado : String = ""
	if acao == "Passe":
		forca = jogador.status.get_passe_forca()
		estado = "FazPasse"
	elif acao == "Arremesso":
		forca = jogador.status.get_arremesso_forca()
		estado = "FazArremesso"
	elif acao == "RoubaBola":
		forca = jogador.status.get_ataque_forca()
		estado = "FazRoubarBola"
	elif acao == "Bloqueio":
		forca = jogador.status.get_ataque_forca()
		estado = "BloqueioFim"
	return [forca, estado]

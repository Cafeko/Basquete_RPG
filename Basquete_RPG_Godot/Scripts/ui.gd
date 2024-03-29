# -<ui>------------------------------------------------------------------------------------------- #
# Gerencia a interface de usuario.
# ------------------------------------------------------------------------------------------------ #
extends CanvasLayer

@onready var menu_acoes = $MenuAcoes
@onready var confirmacao = $Confirmacao
@onready var fim_turno = $FimTurno
@onready var barra_forca = $BarraForca
@onready var barra_forca_botao = $BarraForca/Botao
@onready var valores = $Valores
@onready var valor_esq = $Valores/HBoxContainer/Valor1
@onready var valor_dir = $Valores/HBoxContainer/Valor2
@onready var status_jogador = $StatusJogador
@onready var status_jogador_posicao = $StatusJogador/Control
@onready var placar_container = $Placar
@onready var placar = $Placar/Placar

# Botoes do menu de ações:
@onready var botao_mover = $MenuAcoes/ColorRect/HBoxContainer/Botoes/BotaoMover
@onready var botao_joga_bola = $MenuAcoes/ColorRect/HBoxContainer/Botoes/BotaoJogaBola
@onready var botao_roubar_bola = $MenuAcoes/ColorRect/HBoxContainer/Botoes/BotaoRoubarBola
@onready var botao_defesa = $MenuAcoes/ColorRect/HBoxContainer/Botoes/BotaoDefesa
@onready var botao_descanso = $MenuAcoes/ColorRect/HBoxContainer/Botoes/BotaoDescanso

# Status:
@onready var status_nomes = $StatusJogador/Control/ColorRect/HBoxContainer/HBoxContainer/LabelsNome
@onready var status_valores = $StatusJogador/Control/ColorRect/HBoxContainer/HBoxContainer/LabelsValores
@onready var status_acoes_nome = $StatusJogador/Control/ColorRect/HBoxContainer/AcoesNumero/HBoxContainer/Acoes
@onready var status_acoes_valor = $StatusJogador/Control/ColorRect/HBoxContainer/AcoesNumero/HBoxContainer/Label8
var status_index_dict : Dictionary = {}
var status_nomes_lista : Array = []
var status_valores_lista : Array = []
@onready var status_cansado_texto = $StatusJogador/Control/ColorRect/HBoxContainer/Cansado/Label

var valor_jogador : String
var valor_adversario : String

func _ready():
	Global.ui = self
	Global.entrou_botao_menu.connect(mouse_entrou_botao_menu)
	Global.saiu_botao_menu.connect(mouse_saiu_botao_menu)
	esconde_menu_acoes()
	esconde_confirmacao()
	esconde_fim_turno()
	esconde_barra_forca()
	reset_valores()
	esconde_valores()
	esconde_status_jogador()
	reset_valores()
	prepara_status()
	exibe_placar()
# ------------------------------------------------------------------------------------------------ #

# ------------------------------------------------------------------------------------------------ #
# - Exibe/Esconde:
func exibe_menu_acoes():
	menu_acoes.visible = true

func esconde_menu_acoes():
	menu_acoes.visible = false

func exibe_confirmacao():
	confirmacao.visible = true

func esconde_confirmacao():
	confirmacao.visible = false

func exibe_fim_turno():
	fim_turno.visible = true

func esconde_fim_turno():
	fim_turno.visible = false

func exibe_barra_forca():
	barra_forca.visible = true
	exibe_barra_forca_botao()

func esconde_barra_forca():
	barra_forca.visible = false
	esconde_barra_forca_botao()

func exibe_barra_forca_botao():
	barra_forca_botao.visible = true

func esconde_barra_forca_botao():
	barra_forca_botao.visible = false

func exibe_valores():
	valores.visible = true

func esconde_valores():
	valores.visible = false

func exibe_status_jogador():
	status_jogador.visible = true

func esconde_status_jogador():
	status_jogador.visible = false

func exibe_placar():
	placar_container.visible = true

func esconde_placar():
	placar_container.visible = false
# ------------------------------------------------------------------------------------------------ #

# ------------------------------------------------------------------------------------------------ #
# - Menu Ações
func abre_menu_acoes():
	exibe_menu_acoes()
	verifica_botoes_disponiveis()
	pass

func fecha_menu_acoes():
	esconde_menu_acoes()

func desabilita_botoes():
	botao_mover.disabled = true
	botao_joga_bola.disabled = true
	botao_roubar_bola.disabled = true
	botao_defesa.disabled = true
	botao_descanso.disabled = true

func verifica_botoes_disponiveis():
	desabilita_botoes()
	var jogador : Jogador = Global.controlador.get_jogador_selecionado()
	if jogador == null:
		return
	# Botão Mover:
	botao_mover.disabled = !(jogador.consegue_mover())
	# Botão Joga Bola:
	botao_joga_bola.disabled = !(jogador.consegue_passar_ou_arremessar())
	# Botão Roubar Bola:
	botao_roubar_bola.disabled = !(jogador.consegue_roubar())
	# Botão defesa:
	botao_defesa.disabled = !(jogador.consegue_defender())
	# Botão Descanso:
	botao_descanso.disabled = !(jogador.consegue_descansar())
# ------------------------------------------------------------------------------------------------ #

# ------------------------------------------------------------------------------------------------ #
# - Mouse nos botões do menu de ações:
func mouse_entrou_botao_menu(botao : Button):
	if botao.disabled == false:
		var jogador = Global.controlador.get_jogador_selecionado()
		if botao.name == "BotaoMover":
			# Ação perdida.
			set_cor_em("Acoes", Color.RED)
			set_valor_em("Acoes", jogador.get_acoes_disponiveis() - 1)
		elif botao.name == "BotaoJogaBola":
			# - Passe:
			# Status usado.
			set_cor_em("Passe", Color.DEEP_SKY_BLUE)
			## Energia perdida.
			#set_cor_em("Energia", Color.RED)
			#var energia_atual = jogador.status.get_energia()
			#if energia_atual != 0:
				#var perda_max = jogador.status.get_passe_forca()
				#var nova_energia = energia_atual - perda_max
				#if nova_energia < 0:
					#nova_energia = 0
				#set_valor_em("Energia", str(nova_energia) + " - " + str(energia_atual))
			#else:
				#set_valor_em("Energia", str(energia_atual))
			## Ação perdida.
			#set_cor_em("Acoes", Color.RED)
			#set_valor_em("Acoes", jogador.get_acoes_disponiveis() - 1)
			# - Arremesso:
			# Status usado.
			set_cor_em("Arremesso", Color.DEEP_SKY_BLUE)
			# Energia perdida.
			set_cor_em("Energia", Color.RED)
			var energia_atual = jogador.status.get_energia()
			if energia_atual != 0:
				var perda_max = jogador.status.get_arremesso_forca()
				var nova_energia = energia_atual - perda_max
				if nova_energia < 0:
					nova_energia = 0
				set_valor_em("Energia", str(nova_energia) + " - " + str(energia_atual))
			else:
				set_valor_em("Energia", str(energia_atual))
			# Ação perdida.
			set_cor_em("Acoes", Color.RED)
			set_valor_em("Acoes", jogador.get_acoes_disponiveis() - 1)
		elif botao.name == "BotaoRoubarBola":
			# Status usado.
			set_cor_em("Ataque", Color.DEEP_SKY_BLUE)
			# Energia perdida.
			var energia_atual = jogador.status.get_energia()
			if energia_atual != 0:
				var perda_max = jogador.status.get_ataque_forca()
				var nova_energia = energia_atual - perda_max
				if nova_energia < 0:
					nova_energia = 0
				set_cor_em("Energia", Color.RED)
				set_valor_em("Energia", str(nova_energia) + " - " + str(energia_atual))
			else:
				set_cor_em("Energia", Color.RED)
				set_valor_em("Energia", str(energia_atual))
		elif botao.name == "BotaoDefesa":
			# Status usados.
			set_cor_em("Bloqueio", Color.DEEP_SKY_BLUE)
			set_cor_em("NoAr", Color.DEEP_SKY_BLUE)
			# Ação perdida.
			set_cor_em("Acoes", Color.RED)
			set_valor_em("Acoes", 0)
		elif botao.name == "BotaoDescanso":
			# Ganha energia.
			var energia_max = jogador.status.get_energia_max()
			var energia_atual = jogador.status.get_energia()
			var ganho = jogador.status.ganho_de_energia() * jogador.get_acoes_disponiveis()
			var nova_energia = energia_atual + ganho
			if nova_energia > energia_max:
				nova_energia = energia_max
			set_cor_em("Energia", Color.GREEN)
			set_valor_em("Energia", nova_energia)
			# Ação perdida.
			set_cor_em("Acoes", Color.RED)
			set_valor_em("Acoes", 0)
			# Cansado.
			if nova_energia >= round(energia_max/2.0):
				status_cansado_texto.set("theme_override_colors/font_color",Color.GREEN)

func mouse_saiu_botao_menu(botao : Button):
	if botao.disabled == false:
		set_todos_status_branco()
		set_valores_do_jogador()
		set_status_do_jogador()
# ------------------------------------------------------------------------------------------------ #

# ------------------------------------------------------------------------------------------------ #
# - Status
func abre_status_jogador(lado_esquerdo : bool = true):
	exibe_status_jogador()
	set_todos_status_branco()
	set_valores_do_jogador()
	set_status_do_jogador()
	set_lado_status(lado_esquerdo)

func fecha_status_jogador():
	esconde_status_jogador()

func prepara_status():
	# Prepara a lista nós de nomes dos status e o dicionario de indices.
	var x = 0
	for status in status_nomes.get_children():
		status_nomes_lista.append(status)
		var nome = status.name
		status_index_dict[nome] = x
		x += 1
	status_nomes_lista.append(status_acoes_nome)
	status_index_dict["Acoes"] = x
	# Prepara a lista de nós valores dos status.
	for label in status_valores.get_children():
		status_valores_lista.append(label)
	status_valores_lista.append(status_acoes_valor)

func set_lado_status(esqerda : bool = true):
	if esqerda:
		status_jogador_posicao.set_anchors_preset(Control.PRESET_TOP_LEFT, true)
	else:
		status_jogador_posicao.set_anchors_preset(Control.PRESET_TOP_RIGHT, true)

func set_todos_status_branco():
	for chave in status_index_dict.keys():
		var indice = status_index_dict[chave]
		status_nomes_lista[indice].set("theme_override_colors/font_color",Color.WHITE)
		status_valores_lista[indice].set("theme_override_colors/font_color",Color.WHITE)

func set_status_branco():
	for chave in status_index_dict.keys():
		if chave != "Acoes" and chave != "Energia":
			var indice = status_index_dict[chave]
			status_nomes_lista[indice].set("theme_override_colors/font_color",Color.WHITE)
			status_valores_lista[indice].set("theme_override_colors/font_color",Color.WHITE)

func set_status_vermelho():
	for chave in status_index_dict.keys():
		if chave != "Acoes" and chave != "Energia":
			var indice = status_index_dict[chave]
			status_nomes_lista[indice].set("theme_override_colors/font_color",Color.RED)
			status_valores_lista[indice].set("theme_override_colors/font_color",Color.RED)

func set_cor_em(status_nome : String, cor : Color):
	var indice = status_index_dict[status_nome]
	status_nomes_lista[indice].set("theme_override_colors/font_color",cor)
	status_valores_lista[indice].set("theme_override_colors/font_color",cor)

func set_valor_em(status_nome : String, valor):
	var indice = status_index_dict[status_nome]
	status_valores_lista[indice].text = str(valor)

func set_status_do_jogador():
	var jogador : Jogador = Global.controlador.get_jogador_selecionado()
	if jogador == null:
		return
	set_status_jogador_cansado(jogador.status.ta_cansado())
	if not jogador.tem_acoes():
		set_cor_em("Acoes", Color.DIM_GRAY)

# Define cor do status de acordo com estado do jogador.
func set_status_jogador_cansado(cansado : bool):
	if cansado:
		set_status_vermelho()
		status_cansado_texto.visible = true
		status_cansado_texto.set("theme_override_colors/font_color",Color.RED)
	else:
		set_status_branco()
		status_cansado_texto.visible = false

func set_valores_do_jogador():
	var jogador : Jogador = Global.controlador.get_jogador_selecionado()
	if jogador == null:
		return
	# Passe:
	var indice = status_index_dict["Passe"]
	var valor = jogador.status.get_passe_forca()
	status_valores_lista[indice].text = str(valor)
	# Arremesso:
	indice = status_index_dict["Arremesso"]
	valor = jogador.status.get_arremesso_forca()
	status_valores_lista[indice].text = str(valor)
	# Ataque:
	indice = status_index_dict["Ataque"]
	valor = jogador.status.get_ataque_forca()
	status_valores_lista[indice].text = str(valor)
	# Defesa:
	indice = status_index_dict["Defesa"]
	valor = jogador.status.get_defesa_forca()
	status_valores_lista[indice].text = str(valor)
	# Bloqueio:
	indice = status_index_dict["Bloqueio"]
	valor = jogador.status.get_bloqueio_forca()
	status_valores_lista[indice].text = str(valor)
	# NoAr:
	indice = status_index_dict["NoAr"]
	valor = jogador.status.get_no_ar_forca()
	status_valores_lista[indice].text = str(valor)
	# Energia:
	indice = status_index_dict["Energia"]
	valor = jogador.status.get_energia()
	status_valores_lista[indice].text = str(valor)
	# Ações:
	indice = status_index_dict["Acoes"]
	valor = jogador.get_acoes_disponiveis()
	status_valores_lista[indice].text = str(valor)
# ------------------------------------------------------------------------------------------------ #

# ------------------------------------------------------------------------------------------------ #
# - Valores
func reset_valores():
	valor_esq.text = ""
	valor_dir.text = ""
	valor_jogador = ""
	valor_adversario = ""
	set_valores_branco()

func set_valores_branco():
	valor_esq.set("theme_override_colors/font_color", Color.WHITE)
	valor_dir.set("theme_override_colors/font_color", Color.WHITE)

func set_cor_do_valor(cor : Color, jogador_na_esquerda : bool = true):
	if jogador_na_esquerda:
		valor_esq.set("theme_override_colors/font_color", cor)
	else:
		valor_dir.set("theme_override_colors/font_color", cor)

func set_valor_jogador(texto : String):
	valor_jogador = texto

func set_valor_adversario(texto : String):
	valor_adversario = texto

func atualiza_valores(jogador_na_esquerda : bool = true):
	if jogador_na_esquerda:
		valor_esq.text = valor_jogador
		valor_dir.text = valor_adversario
	else:
		valor_esq.text = valor_adversario
		valor_dir.text = valor_jogador
# ------------------------------------------------------------------------------------------------ #

# ------------------------------------------------------------------------------------------------ #
# - Placar
func placar_atualiza_time_do_turno_cor(cor : Color = Color.BLACK):
	placar.set_cor_time_do_turno(cor)

func placar_set_pontos(pontos : Array):
	placar.set_pontos_time1(pontos[0])
	placar.set_pontos_time2(pontos[1])

func placar_set_cores_times(cor_time1 : Color = Color.BLACK, Cor_time2 : Color = Color.BLACK):
	placar.set_cor_time1(cor_time1)
	placar.set_cor_time2(Cor_time2)

func placar_set_minutos(valor : int):
	placar.set_minutos(valor)

func placar_set_periodo(valor : int):
	placar.set_periodo(valor)
# ------------------------------------------------------------------------------------------------ #

# ------------------------------------------------------------------------------------------------ #
func mouse_entrou():
	Global.controlador.set_mouse_em_botao(true)

func mouse_saiu():
	Global.controlador.set_mouse_em_botao(false)

func on_botao_mover():
	Global.acao_escolhida.emit("Mover")

func on_botao_confirmar():
	Global.confirmar_acao.emit(Global.controlador_estado_atual)

func on_botao_cancelar():
	Global.cancelar_acao.emit(Global.controlador_estado_atual)

func on_botao_fim_turno():
	Global.finalizar_turno.emit()

func on_botao_para_barra():
	Global.para_barra_forca.emit()

func on_botao_roubar_bola():
	Global.acao_escolhida.emit("RoubarBola")

func on_botao_descanso():
	Global.acao_escolhida.emit("Descansar")

func on_botao_fechar():
	Global.acao_escolhida.emit("FecharMenu")

func on_botao_defesa():
	Global.acao_escolhida.emit("Defender")

func on_botao_joga_bola():
	Global.acao_escolhida.emit("JogaBola")

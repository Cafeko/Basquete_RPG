# -<estado_pega_bola_no_ar>----------------------------------------------------------------------- #
# Estado do controlador, faz o jogador que fez a interrupção tentar pegar a bola no ar. 
# ------------------------------------------------------------------------------------------------ #
extends Estado

var agente_interrupcao : Jogador
var bola : Bola
var na_esq : bool
var dificuldade : int
var forca : int

# Executada quando os nós estiverem prontos.
func tudo_pronto():
	Global.defesa_deu_errado.connect(on_defesa_deu_errado)
	Global.defesa_deu_certo.connect(on_defesa_deu_certo)

# Executado quando entra no estado.
func entrando():
	# Valores:
	agente_interrupcao = Global.controlador.get_primeira_interrupcao()
	bola = Global.bola
	dificuldade = bola.forca
	forca = agente_interrupcao.status.defesa_no_ar()
	# Visual (Envolvido na interrupção):
	agente_interrupcao.aparencia.set_contorno(true, Global.cor_selecionado)
	bola.aparencia.set_contorno(true, Global.cor_selecionado)
	# Exibe na tela:
	Global.ui.exibe_valores()
	Global.ui.set_valor_jogador(str(forca))
	Global.ui.set_valor_adversario(str(dificuldade))
	na_esq = Global.controlador.time_na_esquerda(agente_interrupcao.get_time())
	Global.ui.atualiza_valores(na_esq)
	# Executa:
	#Global.para_movimento_bola.emit()
	await get_tree().create_timer(2.0).timeout 
	agente_interrupcao.comeca_defesa_no_ar(bola, dificuldade, forca)

# Executado ao sair do estado
func saindo():
	Global.ui.esconde_valores()
	Global.ui.reset_valores()
	agente_interrupcao.aparencia.set_contorno(false)
	bola.aparencia.set_contorno(false)

# Defesa deu certo: Jogador pega a bola no ar.
func on_defesa_deu_certo(estado_alvo : String):
	if self.name == estado_alvo:
		muda_estado.emit(self.name, "FazendoAcao")
		Global.para_bola_no_ar.emit()
		bola.global_position = agente_interrupcao.global_position
		agente_interrupcao.comeca_pegar_bola(bola)

# Defesa deu errado: 
func on_defesa_deu_errado(estado_alvo : String):
	if self.name == estado_alvo:
		# Remove a interrupcao atual.
		Global.controlador.pop_primeira_interrupcao()
		# Diminui a forca da bola.
		var nova_forca_bola = bola.forca - forca
		if nova_forca_bola < 0:
			nova_forca_bola = 0
		bola.forca = nova_forca_bola
		# Se ainda tem interrupções: Vai executar elas.
		if Global.controlador.tem_interrupcao():
			muda_estado.emit(self.name, "Interrupcao")
		# Se não: Deixa a bola continuar seu movimento.
		else:
			Global.continua_movimento_bola.emit()
			muda_estado.emit(self.name, "FazendoAcao")

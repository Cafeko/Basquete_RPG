# -<estado_bloqueio_fim>----------------------------------------------------------------------- #
# Estado do controlador, faz o jogador que fez a interrupção tentar bloquear o movimento do alvo, 
# com os dados adquiridos anteriormente.
# ------------------------------------------------------------------------------------------------ #
extends Estado

var informacoes
var agente_interrupcao : Jogador
var alvo : Jogador
var dificuldade : int
var forca : int

# Executada quando os nós estiverem prontos.
func tudo_pronto():
	Global.defesa_deu_errado.connect(on_defesa_deu_errado)
	Global.defesa_deu_certo.connect(on_defesa_deu_certo)

# Executado quando entra no estado.
func entrando():
	informacoes = Global.controlador.get_info()
	agente_interrupcao = Global.controlador.get_primeira_interrupcao()
	alvo = informacoes[1]
	dificuldade = informacoes[3]
	forca = informacoes[2]
	agente_interrupcao.comeca_bloquear(alvo, dificuldade, forca)

# Executado ao sair do estado
func saindo():
	Global.visual.limpa_area()
	Global.ui.esconde_valores()
	Global.ui.reset_valores()

# Defesa deu certo: Jogador pega a bola no ar.
func on_defesa_deu_certo(estado_alvo : String):
	if self.name == estado_alvo:
		muda_estado.emit(self.name, "FazendoAcao")
		Global.finaliza_movimento_jogador.emit(alvo)

# Defesa deu errado: 
func on_defesa_deu_errado(estado_alvo : String):
	if self.name == estado_alvo:
		# Remove a interrupcao atual.
		Global.controlador.pop_primeira_interrupcao()
		# Se ainda tem interrupções: Vai executar elas.
		if Global.controlador.tem_interrupcao():
			muda_estado.emit(self.name, "Interrupcao")
		# Se não: Deixa a bola continuar seu movimento.
		else:
			muda_estado.emit(self.name, "FazendoAcao")
			Global.continua_movimento_jogador.emit(alvo)

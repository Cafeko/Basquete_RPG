# -<estado_fazendo_acao>-------------------------------------------------------------------------- #
# Estado do controlador, estado em que a bola entrou na cesta durante um arremesso, marca o ponto e 
# prepara para continuar o jogo após a cesta.
# ------------------------------------------------------------------------------------------------ #
extends Estado

var informacoes : Array
var time_fez_ponto : TimeJogadores
var quantidade_pontos : int
var time_tomou_cesta : TimeJogadores
var lado_esq : bool

# Executado quando entra no estado.
func entrando():
	# Prepara informações.
	informacoes = Global.controlador.get_info()
	time_fez_ponto = informacoes[0]
	quantidade_pontos = informacoes[1]
	time_tomou_cesta = Global.controlador.time_adversario(time_fez_ponto)
	lado_esq = Global.controlador.time_na_esquerda(time_tomou_cesta)
	# Marca ponto.
	Global.controlador.marcar_pontos(time_fez_ponto, quantidade_pontos)
	# Passa turno para time que tomou a cesta.
	Global.controlador.define_time_do_turno(time_tomou_cesta)
	# Prepara quadra e bola.
	Global.quadra.prepara_navegacao()
	#Global.controlador.posiciona_bola_pos_ponto(lado_esq)
	# Posiciona e prepara jogadores.
	Global.controlador.formacao_pos_ponto(time_fez_ponto, time_tomou_cesta)
	Global.controlador.time_pega_bola(time_tomou_cesta)
	Global.controlador.jogador_nao_move_pos_ponto(time_tomou_cesta)

# Executando enquanto está no estado.
func executando(_delta):
	muda_estado.emit(self.name, "SelecionaJogador")

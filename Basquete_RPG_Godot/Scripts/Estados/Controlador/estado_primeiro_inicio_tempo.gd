extends Estado

var fase : int = 0
var primeira : bool = true

func tudo_pronto():
	fase = 0
	primeira = true

# Executando enquanto está no estado.
func executando(_delta):
	if fase == 0:
		Global.quadra.prepara_navegacao()
		Global.controlador.primeiro_inicio_tempo()
		Global.bola.global_position = Global.quadra.get_centro_cord()
		fase = 1
	elif fase == 1:
		await get_tree().create_timer(1.0).timeout
		if primeira:
			primeira = false
			fase = 2
	elif fase == 2:
		Global.bola_move_para.emit(Global.quadra.ponto_alto)
		fase = 3
	elif fase == 3:
		if Global.bola.global_position == Global.quadra.ponto_alto:
			fase = 4
	elif fase == 4:
		await get_tree().create_timer(0.1).timeout
		Global.bola_move_para.emit(Global.quadra.ponto_baixo)
		fase = 5
	elif fase == 5:
		if Global.bola.global_position == Global.quadra.ponto_baixo:
			fase = 6
	elif fase == 6:
		var time = Global.controlador.sorteia_time_do_turno()
		Global.controlador.posiciona_bola_inicio_tempo()
		Global.controlador.jogador_inicial_centro_inicio_tempo(time)
		Global.controlador.time_pega_bola(time)
		fase = 7
	elif fase == 7:
		muda_estado.emit(self.name, "SelecionaJogador")

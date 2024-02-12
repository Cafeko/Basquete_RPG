extends Acao

@export var corpo : Jogador

func faze_de_preparacao(_info : Array):
	corpo.aparencia.toca_animacao("Parado")

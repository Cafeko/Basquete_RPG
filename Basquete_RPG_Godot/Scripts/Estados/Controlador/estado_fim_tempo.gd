extends Estado

@onready var timer = $Timer

# Executado quando entra no estado.
func entrando():
	timer.start(1.5)
	Global.sons.toca_som("FimTempo")

func on_timeout():
	if Global.controlador.jogo_acabou():
		Global.time_ganhou = Global.controlador.time_que_ganhou()
		Global.muda_cena.emit("res://Cenas/game_over_screen.tscn")
	else:
		muda_estado.emit(self.name, "InicioTempo")

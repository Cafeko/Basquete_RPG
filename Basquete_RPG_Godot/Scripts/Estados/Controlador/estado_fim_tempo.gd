extends Estado

@onready var timer = $Timer

# Executado quando entra no estado.
func entrando():
	timer.start(1.5)

func on_timeout():
	if Global.controlador.jogo_acabou():
		get_tree().change_scene_to_file("res://Cenas/game_over_screen.tscn");
	else:
		muda_estado.emit(self.name, "InicioTempo")

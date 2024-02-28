extends Estado

@onready var timer = $Timer

# Executado quando entra no estado.
func entrando():
	timer.start(1.5)

func on_timeout():
	if Global.controlador.jogo_acabou():
		Global.time_ganhou = Global.controlador.time_que_ganhou()
		var nova_cena = preload("res://Cenas/game_over_screen.tscn").instantiate()
		get_tree().root.add_child(nova_cena)
		var main = get_tree().root.get_node("/root/Main")
		get_tree().root.remove_child(main)
	else:
		muda_estado.emit(self.name, "InicioTempo")

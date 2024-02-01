extends Button

func on_mouse_entered():
	Global.entrou_botao_menu.emit(self)

func on_mouse_exited():
	Global.saiu_botao_menu.emit(self)

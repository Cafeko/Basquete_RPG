extends CanvasLayer

@export var texto : Label

var time_vencedor : TimeJogadores

func _ready():
	time_vencedor = Global.time_ganhou
	if time_vencedor != null:
		texto.text = time_vencedor.name + " venceu!"
	else:
		texto.text = "Empate"
	pass

func _on_quit_button_pressed():
	Global.muda_cena.emit("res://Tela_Inicial/Cena_Tela_Inicial.tscn")

func _on_restart_button_pressed():
	Global.muda_cena.emit("res://Cenas/Jogo.tscn")

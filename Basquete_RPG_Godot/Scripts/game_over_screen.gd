extends CanvasLayer

@export var texto : Label

var time_vencedor : TimeJogadores

func _ready():
	time_vencedor = Global.time_ganhou
	texto.text = time_vencedor.name + " venceu!"
	pass

func _on_quit_button_pressed():
	get_tree().change_scene_to_file("res://Tela_Inicial/Cena_Tela_Inicial.tscn");

func _on_restart_button_pressed():
	get_tree().change_scene_to_file("res://Cenas/Main.tscn");

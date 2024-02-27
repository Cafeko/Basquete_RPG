extends CanvasLayer

func _on_quit_button_pressed():
	get_tree().change_scene_to_file("res://Tela_Inicial/Cena_Tela_Inicial.tscn");


func _on_restart_button_pressed():
	get_tree().change_scene_to_file("res://Cenas/Main.tscn");

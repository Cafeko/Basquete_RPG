extends Node

func _ready():
	Global.controle_cena = self
	Global.muda_cena.connect(muda_cena)

func muda_cena(cena : String):
	var cena_atual = get_children()[0]
	var nova_cena = load(cena)
	var nova_cena_instancia = nova_cena.instantiate()
	cena_atual.queue_free()
	add_child(nova_cena_instancia)

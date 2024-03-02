extends Node

@onready var som_arremesso = $SomArremesso
@onready var som_passe = $SomPasse
@onready var som_fim_tempo = $SomFimTempo
@onready var som_pega_bola = $SomPegaBola

func _ready():
	Global.sons = self

func toca_som(som_nome : String):
	if som_nome == "Arremesso":
		som_arremesso.play()
	elif som_nome == "Passe":
		som_passe.play()
	elif som_nome == "FimTempo":
		som_fim_tempo.play()
	elif som_nome == "PegaBola":
		som_pega_bola.play()

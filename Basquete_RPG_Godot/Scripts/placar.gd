extends Node2D

@onready var numero_tempo = $Textos/VBoxContainer/HBoxContainer/NumeroTempo
@onready var tenpo_minutos = $Textos/VBoxContainer/HBoxContainer/TempoMinutos
@onready var time_turno_cor = $Textos/VBoxContainer/HBoxContainer/ColorRect
@onready var time1_cor = $Textos/VBoxContainer/HBoxContainer2/ColorRect
@onready var time1_pontos = $Textos/VBoxContainer/HBoxContainer2/HBoxContainer/PontosTime1
@onready var time2_pontos = $Textos/VBoxContainer/HBoxContainer2/HBoxContainer/PontosTime2
@onready var time2_cor = $Textos/VBoxContainer/HBoxContainer2/ColorRect2

func set_cor_time1(cor : Color):
	time1_cor.color = cor

func set_cor_time2(cor : Color):
	time2_cor.color = cor

func set_cor_time_do_turno(cor : Color):
	time_turno_cor.color = cor

func set_pontos_time1(valor : int):
	time1_pontos.text = str(valor)

func set_pontos_time2(valor : int):
	time2_pontos.text = str(valor)

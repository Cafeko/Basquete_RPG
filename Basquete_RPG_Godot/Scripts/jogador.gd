extends CharacterBody2D
class_name Jogador

@onready var mover = $Mover

var acao_atual = null

signal acao_fim

func _ready():
	var tile = Global.quadra.cord_para_tile(self.global_position)
	Global.quadra.set_tile_nao_navegavel(tile)
	self.global_position = Global.quadra.tile_para_cord(tile)
	mover.fim.connect(fim_mover)

func _physics_process(delta):
	if acao_atual != null:
		acao_atual.executando(delta)

func comeca_mover(caminho : Array[Vector2i]):
	Global.quadra.set_tile_navegavel(Global.quadra.cord_para_tile(self.global_position))
	acao_atual = mover
	acao_atual.faze_de_preparacao([caminho])

func fim_mover():
	Global.quadra.set_tile_nao_navegavel(Global.quadra.cord_para_tile(self.global_position))
	acao_atual.finalizacao()
	acao_atual = null
	acao_fim.emit()

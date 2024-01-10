# -<maquina_estados>------------------------------------------------------------------------------ #
# Guarda e gerencia os estados do jogo, fazendo a mudança de estado e executando o estado atual.
# ------------------------------------------------------------------------------------------------ #
extends Node

@export var primeiro_estado : Estado

var estados_dict : Dictionary
var estado_atual : Estado

func _ready():
	# Adiciona os estados em um dicionario de estado para serem acessados pelo nome.
	for estado in get_children():
		if estado is Estado:
			estados_dict[estado.name] = estado
			estado.muda_estado.connect(on_muda_estado)
	# Coloca o primeiro estado como o estado atual.
	estado_atual = primeiro_estado

func _process(delta):
	# Fica executando o estado atual.
	estado_atual.executando(delta)

# Muda o estado atual para um novo estado.
func on_muda_estado(estado_nome : String, novo_estado_nome : String):
	# Verifica se o estado que emitiu o sinal é o estado atual.
	if estado_atual.name != estado_nome:
		return
	# Verifica se o novo estado existe.
	if not novo_estado_nome in estados_dict.keys():
		return
	var novo_estado = estados_dict[novo_estado_nome]
	# Faz a transição entre os estados.
	estado_atual.saindo()
	novo_estado.entrando()
	estado_atual = novo_estado

# Executa a função tudo_pronto para todos os estados.
func executar_tudo_pronto():
	for estado in estados_dict.values():
		estado.tudo_pronto()

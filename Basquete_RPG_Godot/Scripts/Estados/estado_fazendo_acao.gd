extends Estado

# Executada quando o controlador for inicializado.
func controlador_pronto():
	Global.controlador.acabou_acao.connect(on_acabou_acao)

func on_acabou_acao():
	muda_estado.emit(self.name, "SelecionaJogador")

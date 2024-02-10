# -<controlador_aparencia_cesta>------------------------------------------------------------------ #
# Controlador de aparencia da cesta.
# ------------------------------------------------------------------------------------------------ #
extends Aparencia

func on_animation_finished(anim_name):
	if anim_name == "BolaNaCesta":
		pai.bola_entrou_na_cesta()

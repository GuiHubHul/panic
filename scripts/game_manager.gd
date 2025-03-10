extends Node

# Sinal para notificar quando o nível de ansiedade mudar
signal anxiety_changed(new_anxiety)

# Variável para armazenar o nível de ansiedade
var anxiety: int = 1:
	set(value):
		anxiety = clamp(value, 1, 4)  # Garante que a ansiedade fique entre 1 e 4
		emit_signal("anxiety_changed", anxiety)  # Notifica que a ansiedade mudou

# Função para aumentar a ansiedade
func increase_anxiety():
	anxiety += 1

# Função para diminuir a ansiedade
func decrease_anxiety():
	anxiety -= 1

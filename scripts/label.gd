extends Label

# Referência ao GameManager
@onready var game_manager: Node = %GameManager

# Dicionário para mapear os estados de ansiedade
var anxiety_states: Dictionary = {
	1: "Calm",
	2: "Nervous",
	3: "Anxious",
	4: "Panic"
}

# Função _ready para conectar o sinal
func _ready():
	# Conecta o sinal "anxiety_changed" à função "on_anxiety_changed" usando Callable
	game_manager.connect("anxiety_changed", Callable(self, "on_anxiety_changed"))
	
	# Atualiza o texto inicial
	text = "Mood: " + anxiety_states[game_manager.anxiety]

# Função chamada quando o nível de ansiedade muda
func on_anxiety_changed(new_anxiety: int):
	text = "Mood: " + anxiety_states[new_anxiety]

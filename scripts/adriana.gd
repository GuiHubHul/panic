extends CharacterBody2D

# Referência ao GameManager (usando @onready para garantir que ele seja carregado)
@onready var game_manager: Node = %GameManager

# Referência ao AnimatedSprite2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

# Referência à nova Label para exibir resultados das ações
@onready var action_status_label: Label = $"../ActionStatusLabel"


# Variável para armazenar o estado anterior da ansiedade
var previous_anxiety: int = 1  # Inicializa com um valor padrão

# Função _ready para inicializar previous_anxiety
func _ready():
	if game_manager:
		previous_anxiety = game_manager.anxiety

# Função para atualizar o estado de humor com base na ansiedade
func update_mood_state():
	match game_manager.anxiety:
		1:
			play_transition("calm")  # Estado: Calm
		2:
			play_transition("nervous")  # Estado: Nervous
		3:
			play_transition("anxious")  # Estado: Anxious
		4:
			play_transition("panic")  # Estado: Panic

# Função para tocar a animação de transição e depois a animação de idle correspondente
func play_transition(idle_animation: String):
	if animated_sprite:
		# Decide qual animação de transição tocar (scare ou relax)
		if game_manager.anxiety > previous_anxiety:
			animated_sprite.play("scare")  # Ansiedade aumentou
		elif game_manager.anxiety < previous_anxiety:
			animated_sprite.play("relax")  # Ansiedade diminuiu
		
		# Espera a animação de transição terminar
		await animated_sprite.animation_finished
		
		# Toca a animação de idle correspondente
		animated_sprite.play(idle_animation)
		
		# Atualiza o estado anterior da ansiedade
		previous_anxiety = game_manager.anxiety

# Função _process para verificar entrada do teclado
func _process(delta):
	# Verifica se a seta para cima foi pressionada
	if Input.is_action_just_pressed("ui_up"):
		game_manager.increase_anxiety()
		update_mood_state()
	
	# Verifica se a seta para baixo foi pressionada
	if Input.is_action_just_pressed("ui_down"):
		game_manager.decrease_anxiety()
		update_mood_state()
	
	# Verifica se a tecla "D" foi pressionada (abrir porta)
	if Input.is_action_just_pressed("abrir_porta"):
		tentar_abrir_porta()
	
	# Verifica se a tecla "S" foi pressionada (correr)
	if Input.is_action_just_pressed("correr"):
		tentar_correr()

# Função para tentar abrir a porta
func tentar_abrir_porta():
	var sucesso: bool = calcular_sucesso()
	
	if action_status_label:
		if sucesso:
			action_status_label.text = "Adriana abriu a porta.!"
			mudar_cor_texto(Color.WEB_GREEN)  # Muda a cor para verde
		else:
			action_status_label.text = "Adriana derrubou a chave."
			mudar_cor_texto(Color.FIREBRICK)  # Muda a cor para vermelho

# Função para tentar correr
func tentar_correr():
	var sucesso: bool = calcular_sucesso()
	
	if action_status_label:
		if sucesso:
			action_status_label.text = "Adriana escapou!"
			mudar_cor_texto(Color.WEB_GREEN)  # Muda a cor para verde
		else:
			action_status_label.text = "Adriana tropeçou e caiu."
			mudar_cor_texto(Color.FIREBRICK)  # Muda a cor para vermelho

# Função para mudar a cor do texto temporariamente
func mudar_cor_texto(cor: Color):
	action_status_label.add_theme_color_override("font_color", cor)  # Muda a cor do texto
	await get_tree().create_timer(1.0).timeout  # Espera 1 segundo
	action_status_label.remove_theme_color_override("font_color")  # Volta ao branco

# Função para calcular a probabilidade de sucesso
func calcular_sucesso() -> bool:
	var probabilidade: float
	
	# Define a probabilidade com base no estado de ansiedade
	match game_manager.anxiety:
		1:
			probabilidade = 1.0  # 100%
		2:
			probabilidade = 0.7  # 70%
		3:
			probabilidade = 0.4  # 40%
		4:
			probabilidade = 0.2  # 20%
	
	# Gera um número aleatório entre 0 e 1
	var sorteio: float = randf()
	
	# Retorna true se o sorteio for menor ou igual à probabilidade
	return sorteio <= probabilidade

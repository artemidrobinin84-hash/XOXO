extends SpineSprite

# Путь к прогрессбару (проверь, чтобы путь соответствовал твоей сцене)
@onready var health_bar = get_node("/root/lvl1/XOXOProgressBar/ProgressBar")
@onready var phase_sound = $PhaseSound
var current_skin = ""

func _ready():
	# 1. Запуск анимации idle. 
	# Правильный синтаксис: set_animation(название, loop, track)
	var animation_state = get_animation_state()
	if animation_state:
		animation_state.set_animation("idle", true, 0)
	
	# 2. Первичная настройка скина при старте
	if health_bar:
		_update_visuals(health_bar.value)

func _process(_delta):
	# Следим за здоровьем и обновляем стадию (level1, level2, level3)
	if health_bar:
		_update_visuals(health_bar.value)

func _update_visuals(hp_value: float):
	var target_skin = ""
	
	# Твои условия по фазам здоровья
	if hp_value >= 67:
		target_skin = "level1"
	elif hp_value >= 34:
		target_skin = "level2"
	else:
		target_skin = "level3"
	
	# Если скин уже установлен, выходим из функции
	if current_skin == target_skin:
		return
		
	var skeleton = get_skeleton()
	if skeleton:
		# Устанавливаем новый скин из Spine
		skeleton.set_skin_by_name(target_skin)
		# Сбрасываем позу, чтобы новые элементы скина отобразились корректно
		skeleton.set_to_setup_pose()
		if current_skin != "" and phase_sound:
			print("Смена фазы: играю звук")
			phase_sound.play()
		
		# 2. И только теперь записываем новый скин в переменную
		current_skin = target_skin
		print("Фаза изменена на: ", target_skin)

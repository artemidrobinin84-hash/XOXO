extends SpineSprite

const BUBBLE_SCENE = preload("res://UI/Dialogue/speech_bubble.tscn")
@onready var health_bar = get_node("../ProgressBar/XOXOProgressBar")
@onready var phase_sound = $Phase_sound
@onready var boss_hitbox = get_node("../GirlHitbox")
@onready var Attack_Sound = $Attack_Sound
@onready var Dammage_Sound = $Dammage_Sound

var current_skin = ""
var boss_phrases = [
	"Cute, but try harder!",
	"My grandma throws better!",
	"Keep dreaming!",
]

func _ready():
	var animation_state = get_animation_state()
	if animation_state:
		animation_state.set_animation("idle", true, 0)
	
	if not self.animation_completed.is_connected(_on_spine_animation_completed):
		self.animation_completed.connect(_on_spine_animation_completed)
	
	await get_tree().process_frame
	if health_bar:
		_update_visuals(health_bar.value)
	
	await get_tree().create_timer(1.0).timeout
	say_something(boss_phrases.pick_random())
	
	$SpeechTimer.timeout.connect(_on_speech_timer_timeout)
	_set_random_timer()

func _process(_delta):
	if health_bar and get_skeleton():
		_update_visuals(health_bar.value)

func _update_visuals(hp_value: float):
	var target_skin = ""
	if hp_value >= 67: target_skin = "level1"
	elif hp_value >= 34: target_skin = "level2"
	else: target_skin = "level3"
	
	if current_skin == target_skin: return
		
	var skeleton = get_skeleton()
	if skeleton:
		skeleton.set_skin_by_name(target_skin)
		skeleton.set_to_setup_pose()
		if current_skin != "" and phase_sound:
			phase_sound.play()
		current_skin = target_skin

# --- ОСНОВНАЯ ФУНКЦИЯ АТАКИ ---
func perform_enemy_attack():
	var animation_state = get_animation_state()
	if animation_state:
		animation_state.clear_tracks()
		var skeleton = get_skeleton()
		if skeleton:
			skeleton.set_to_setup_pose()
		animation_state.set_animation("attack", false, 0)
		Attack_Sound.play()
		Dammage_Sound.play()
	
	if boss_hitbox:
		# 1. Рассчитываем урон
		var damage_amount = randi_range(10, 30)
		
		# 2. Наносим урон через хитбокс
		boss_hitbox.deal_damage_to_player(damage_amount)
		
		# 3. Выводим число на экран
		_show_damage_at_pos(damage_amount)

func _on_spine_animation_completed(_sprite, _track_entry, _track_index):
	var animation_state = get_animation_state()
	if animation_state:
		animation_state.set_animation("idle", true, 0)

# Функция для обычных фраз
func say_something(message: String):
	var bubble = BUBBLE_SCENE.instantiate()
	get_parent().add_child(bubble)
	var base_pos = $MouthPos.global_position
	var offset = Vector2(randf_range(-450, 250), randf_range(-160, 150))
	bubble.global_position = base_pos + offset
	bubble.set_text(message)

# НОВАЯ ФУНКЦИЯ: Показ урона
func _show_damage_at_pos(amount: int):
	var damage_bubble = BUBBLE_SCENE.instantiate()
	get_parent().add_child(damage_bubble)
	
	# Выводим урон чуть выше рта или в фиксированной точке
	damage_bubble.global_position = $MouthPos.global_position + Vector2(0, -100)
	
	# Форматируем текст (например: "-25 HP")
	damage_bubble.set_text("-" + str(amount) + " HP")
	
	# По желанию: можно добавить красный оттенок, если в сцене есть Label
	# damage_bubble.modulate = Color(1, 0.3, 0.3) 

func _on_speech_timer_timeout():
	var phrase : String
	if current_skin == "level3":
		phrase = ["I can't think straight!", "MORE!", "Take it all!", "Don't stop!"].pick_random()
	elif current_skin == "level2":
		phrase = ["Wait, stop looking!", "It's getting breezy...", "Why am I not stopping you?"].pick_random()
	else:
		phrase = ["Cute, but try harder!", "My grandma throws better!", "Keep dreaming!"].pick_random()
	say_something(phrase)
	_set_random_timer()

func _set_random_timer():
	$SpeechTimer.wait_time = randf_range(20.0, 25.0)
	$SpeechTimer.start()
"res://lvl/lvlTutor.tscn"

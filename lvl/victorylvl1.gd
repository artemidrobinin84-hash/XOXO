extends CanvasLayer

@onready var next_level_btn = $HBoxContainer/NextLevelButton
@onready var main_menu_btn = $HBoxContainer/MainMenuButton
@onready var click_sound = $"../Click"
# Путь к боссу, чтобы подписаться на его смерть
@onready var boss = get_tree().get_first_node_in_group("enemy")

func _ready():
	# Скрываем слой при запуске
	hide()
	$HBoxContainer/NextLevelButton.mouse_entered.connect(_on_button_hover)
	$HBoxContainer/MainMenuButton.mouse_entered.connect(_on_button_hover)
	# Подключаем кнопки кодом (можно и через инспектор)
	next_level_btn.pressed.connect(_on_next_level_pressed)
	main_menu_btn.pressed.connect(_on_main_menu_pressed)
	# Подписываемся на сигнал победы из твоего GirlHitbox
	if boss:
		boss.boss_defeated.connect(_on_victory)
func _on_button_hover() -> void:
	click_sound.play()
func _on_victory():
	show()
	$Label2.text = ["She's yours now!", "She’s crazy about you.", "Damn, you definitely
	 cooked her."].pick_random() # Показываем экран победы
	# Если нужно остановить игру, раскомментируй строку ниже:
	# get_tree().paused = true 

func _on_next_level_pressed():
	click_sound.play()
	await get_tree().create_timer(0.15).timeout
	get_tree().paused = false
	get_tree().change_scene_to_file("res://lvl/lvl2.tscn")

func _on_main_menu_pressed():
	click_sound.play()
	await get_tree().create_timer(0.15).timeout
	get_tree().paused = false
	get_tree().change_scene_to_file("res://UI/MainMenu/MainMenu.tscn")

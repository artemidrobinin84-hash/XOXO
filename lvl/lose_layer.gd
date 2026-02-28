extends CanvasLayer

@onready var Restart1 = $HBoxContainer/Restart1
@onready var MainMenu1 = $HBoxContainer/MainMenuButton1
@onready var click_sound = $"../Click"
# Путь к боссу, чтобы подписаться на его смерть
@onready var boss = get_tree().get_first_node_in_group("enemy")

func _ready():
	# Скрываем слой при запуске
	hide()
	Restart1.mouse_entered.connect(_on_button_hover)
	MainMenu1.mouse_entered.connect(_on_button_hover)
	Restart1.pressed.connect(_on_restart_pressed)
	MainMenu1.pressed.connect(_on_main_menu_button_pressed)
	# Подписываемся на сигнал победы из твоего GirlHitbox
	if boss:
		boss.boss_win.connect(_on_lose)
func _on_button_hover() -> void:
	click_sound.play()
func _on_lose():
	show() # Показываем экран победы
	# Если нужно остановить игру, раскомментируй строку ниже:
	# get_tree().paused = true 

func _on_restart_pressed():
	click_sound.play()
	await get_tree().create_timer(0.15).timeout
	get_tree().paused = false
	get_tree().change_scene_to_file("res://lvl/lvl2.tscn")

func _on_main_menu_button_pressed():
	click_sound.play()
	await get_tree().create_timer(0.15).timeout
	get_tree().paused = false
	get_tree().change_scene_to_file("res://UI/MainMenu/MainMenu.tscn")

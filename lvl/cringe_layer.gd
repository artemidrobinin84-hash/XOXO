extends CanvasLayer

@onready var Restart1 = $HBoxContainer/Restart1
@onready var MainMenu1 = $HBoxContainer/MainMenuButton1
@onready var click_sound = $Click
# Путь к боссу, чтобы подписаться на его смерть
@onready var boss = get_tree().get_first_node_in_group("enemy")

func _ready():
	# Скрываем слой при запуске
	hide()
	Restart1.mouse_entered.connect(_on_button_hover)
	MainMenu1.mouse_entered.connect(_on_button_hover)
	# Подписываемся на сигнал победы из твоего GirlHitbox
	if boss:
		boss.cringe_game.connect(_on_cringe)
func _on_button_hover() -> void:
	click_sound.play()
func _on_cringe():
	show() 
	$Label2.text = ["Bro, you're cringe,
	 the main character aura
	 won't help you here."].pick_random()# Показываем экран победы
	# Если нужно остановить игру, раскомментируй строку ниже:
	# get_tree().paused = true 

func _on_restart_1_pressed():
	click_sound.play()
	await get_tree().create_timer(0.15).timeout
	get_tree().paused = false
	get_tree().reload_current_scene()
func _on_main_menu_button_1_pressed():
	click_sound.play()
	await get_tree().create_timer(0.15).timeout
	get_tree().paused = false
	get_tree().change_scene_to_file("res://UI/MainMenu/MainMenu.tscn")

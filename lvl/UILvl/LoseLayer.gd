extends CanvasLayer

@onready var restart_btn = $HBoxContainer/Restart1
@onready var main_menu_btn = $HBoxContainer/MainMenuButton1
@onready var click_sound = $Click # Проверь путь к звуку, в виктори он $"../Click"

@onready var boss = get_tree().get_first_node_in_group("enemy")

func _ready():
	hide()
	# Наведение
	restart_btn.mouse_entered.connect(_on_button_hover)
	main_menu_btn.mouse_entered.connect(_on_button_hover)
	# Нажатие
	restart_btn.pressed.connect(_on_restart_pressed)
	main_menu_btn.pressed.connect(_on_main_menu_pressed)
	
	if boss:
		boss.boss_win.connect(_on_lose)

func _on_button_hover() -> void:
	click_sound.play()

func _on_lose():
	show()
	$Label2.text = ["Next time, choose who you flirt carefully.", "Weak moves, bro.", "Did you lose to her?"].pick_random()
	# Чтобы кнопки работали после этой строки, читай инструкцию ниже!
	get_tree().paused = true 

func _on_restart_pressed():
	click_sound.play()
	await get_tree().create_timer(0.15).timeout
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_main_menu_pressed():
	click_sound.play()
	await get_tree().create_timer(0.15).timeout
	get_tree().paused = false
	get_tree().change_scene_to_file("res://UI/MainMenu/MainMenu.tscn")

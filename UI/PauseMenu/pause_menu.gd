extends Control


func _ready():
	# Скрываем меню при старте
	hide()
	# Убеждаемся, что игра НЕ на паузе
	get_tree().paused = false

func _input(event):
	# Проверяем нажатие Esc
	if event.is_action_pressed("Esc"):
		toggle_pause()

func toggle_pause():
	# Переключаем паузу в движке
	get_tree().paused = !get_tree().paused
	# Показываем или скрываем меню
	visible = get_tree().paused

func _on_resume_button_pressed():
	toggle_pause()

func _on_quit_button_pressed():
	get_tree().quit()

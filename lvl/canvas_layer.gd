class_name PauseMenu
extends CanvasLayer
@onready var click_sound = $"../../../Click"
func _ready() -> void:
	$HBoxContainer/Continue.mouse_entered.connect(_on_button_hover)
	$HBoxContainer/Restart.mouse_entered.connect(_on_button_hover)
	$HBoxContainer/BackToMenu.mouse_entered.connect(_on_button_hover)
func _on_button_hover() -> void:
	click_sound.play()
func _notification(what: int) -> void:
	match what:
		Node.NOTIFICATION_PAUSED:
			show()
		Node.NOTIFICATION_UNPAUSED:
			hide()
func _on_continue_pressed() -> void:
	get_tree().paused = false
	hide()
	click_sound.play()

func _on_restart_pressed() -> void:
	click_sound.play()
	await get_tree().create_timer(0.15).timeout
	get_tree().paused = false
	get_tree().reload_current_scene()

# 3. Кнопка "В меню"
func _on_back_to_menu_pressed() -> void:
	click_sound.play()
	await get_tree().create_timer(0.15).timeout
	get_tree().paused = false
	get_tree().change_scene_to_file("res://UI/MainMenu/MainMenu.tscn")

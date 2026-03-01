extends CanvasLayer

@onready var click_sound = $"../Click"

func _ready() -> void:
	hide()
	
	process_mode = Node.PROCESS_MODE_ALWAYS
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		toggle_pause()

func toggle_pause():
	var new_pause_state = !get_tree().paused
	get_tree().paused = new_pause_state
	
	visible = new_pause_state

func _on_continue_pressed() -> void:
	if click_sound: click_sound.play()
	get_tree().paused = false
	hide()

func _on_restart_pressed() -> void:
	if click_sound: click_sound.play()
	await get_tree().create_timer(0.15, true).timeout
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_back_to_menu_pressed() -> void:
	if click_sound: click_sound.play()
	await get_tree().create_timer(0.15, true).timeout
	get_tree().paused = false
	get_tree().change_scene_to_file("res://UI/MainMenu/MainMenu.tscn")

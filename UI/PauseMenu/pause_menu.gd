extends Control


func _ready():
	hide()
	get_tree().paused = false

func _input(event):
	if event.is_action_pressed("Esc"):
		print("Работает")
		toggle_pause()

func toggle_pause():
	get_tree().paused = !get_tree().paused
	visible = get_tree().paused
	show()

func _on_resume_button_pressed():
	toggle_pause()

func _on_quit_button_pressed():
	get_tree().quit()

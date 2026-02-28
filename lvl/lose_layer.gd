extends CanvasLayer

@onready var Restart1 = $HBoxContainer/Restart1
@onready var MainMenu1 = $HBoxContainer/MainMenuButton1
@onready var click_sound = $Click
@onready var boss = get_tree().get_first_node_in_group("enemy")

func _ready():
	hide()
	Restart1.mouse_entered.connect(_on_button_hover)
	MainMenu1.mouse_entered.connect(_on_button_hover)
	Restart1.pressed.connect(_on_restart_pressed)
	MainMenu1.pressed.connect(_on_main_menu_button_pressed)
	if boss:
		boss.boss_win.connect(_on_lose)
func _on_button_hover() -> void:
	click_sound.play()
func _on_lose():
	show()
	$Label2.text = ["Next time,
	 choose who you flirt 
	with more carefully.", "Weak moves, bro. 
	Keep practicing", "Did you really
	 just lose to her?"].pick_random()

func _on_restart_pressed():
	click_sound.play()
	await get_tree().create_timer(0.15).timeout
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_main_menu_button_pressed():
	click_sound.play()
	await get_tree().create_timer(0.15).timeout
	get_tree().paused = false
	get_tree().change_scene_to_file("res://UI/MainMenu/MainMenu.tscn")

extends CanvasLayer

@onready var main_menu_btn = $HBoxContainer/MainMenuButton
@onready var click_sound = $"../Click"
@onready var boss = get_tree().get_first_node_in_group("enemy")

func _ready():
	hide()
	$HBoxContainer/MainMenuButton.mouse_entered.connect(_on_button_hover)
	main_menu_btn.pressed.connect(_on_main_menu_pressed)
	if boss:
		boss.boss_defeated.connect(_on_victory)
func _on_button_hover() -> void:
	click_sound.play()
func _on_victory():
	show()
	$Label2.text = ["Thank you for playing our game!"].pick_random()

func _on_main_menu_pressed():
	click_sound.play()
	await get_tree().create_timer(0.15).timeout
	get_tree().paused = false
	get_tree().change_scene_to_file("res://UI/MainMenu/MainMenu.tscn")

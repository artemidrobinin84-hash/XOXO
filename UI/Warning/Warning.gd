extends Node2D
@onready var click_sound = $Click
func _on_button_pressed():
	click_sound.play()
	await get_tree().create_timer(0.15).timeout
	get_tree().change_scene_to_file("res://UI/MainMenu/MainMenu.tscn")

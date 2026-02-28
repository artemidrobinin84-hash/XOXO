class_name GameplayManager
extends Node


@export var gameplay_actions : GameplayActions
@export var pause_menu : PauseMenu
func _input(event):
	if event.is_action_pressed(gameplay_actions.pause):
		toggle_pause()
		
func toggle_pause():
	get_tree().paused = !get_tree().paused
	pause_menu.visible = get_tree().paused

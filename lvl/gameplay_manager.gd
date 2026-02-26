class_name GameplayManager
extends Node


# Called when the node enters the scene tree for the first time.
@export var gameplay_actions : GameplayActions

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event):
	if event.is_action_pressed(gameplay_actions.pause):
		toggle_pause()
		
func toggle_pause():
	get_tree().paused = !get_tree().paused

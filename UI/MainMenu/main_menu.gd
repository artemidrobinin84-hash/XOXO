extends Control

func _ready() -> void:
	#_Exit()
	_Sound()
	_SoundExit()
	#_Support()
	#_SupportExit()
	_Play()
# Called when the node enters the scene tree for the first time.
func _Play() -> void:
	$Background/Play.pressed.connect(_on_play_pressed)
	


func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://lvl/lvl1.tscn")


#func _Support() -> void:
	#$menu/MenuUi/Support.pressed.connect(_on_support_pressed)
	#
#
func _Sound() -> void:
	$Background/Sound.pressed.connect(_on_settings_pressed)
	
#func _SupportExit() -> void:
	#$menu/MenuUi/Control2/SupportUi/Button.pressed.connect(_on_exit_support_pressed)
#
#
#func _SoundExit() -> void:
	#$menu/MenuUi/Control/SettingsUi/Button.pressed.connect(_on_exit_settings_pressed)
#
#
#func _Exit() -> void:
	#$menu/MenuUi/Exit.pressed.connect(_on_exit_pressed)
#
#
#func _on_exit_pressed() -> void:
	#get_tree().quit()
#
#func _on_support_pressed() -> void:
	#print("nasal")
	#$menu/MenuUi/Control2.mouse_filter = Control.MOUSE_FILTER_STOP
	#$menu/MenuUi/Control2/SupportUi.show()
#
func _on_settings_pressed() -> void:
	print("nasal")
	$Background/Sound_Settings.mouse_filter = Control.MOUSE_FILTER_STOP
	$Background/Sound_Settings.show()
#
#func _on_exit_support_pressed() -> void:
	#print("lol")
	#$menu/MenuUi/Control2/SupportUi.visible = false
	#$menu/MenuUi/Control2.mouse_filter = Control.MOUSE_FILTER_IGNORE
#
#
func _SoundExit() -> void:
	print("lol")
	$menu/MenuUi/Control/SettingsUi.visible = false
	$menu/MenuUi/Control.mouse_filter = Control.MOUSE_FILTER_IGNORE

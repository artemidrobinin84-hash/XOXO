extends Control

func _ready() -> void:
	#_Exit()
	_Sound()
	_SoundExit()
	_Credit()
	_CreditExit()
	_Play()
# Called when the node enters the scene tree for the first time.
func _Play() -> void:
	$Background/Play.pressed.connect(_on_play_pressed)
	

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://lvl/lvl1.tscn")


func _Credit() -> void:
	$Background/Credit.pressed.connect(open_credit)
	

func _Sound() -> void:
	$Background/Sound.pressed.connect(open_settings)
func _CreditExit() -> void:
	$Background/CreditMenu/TextureRect1/Exit1.pressed.connect(close_credit)

func _SoundExit() -> void:
	$Background/Sound_Settings/TextureRect/Exit.pressed.connect(close_settings)
#
#func _Exit() -> void:
	#$menu/MenuUi/Exit.pressed.connect(_on_exit_pressed)
#
#
#func _on_exit_pressed() -> void:
	#get_tree().quit()
#
func _on_credit_pressed() -> void:
	print("nasal")
	$Background/CreditMenu.mouse_filter = Control.MOUSE_FILTER_STOP
	$Background/CreditMenu.show()
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
func _SoundExit1() -> void:
	print("lol")
	$Background/Sound_Settings.visible = false
	$Background/Sound_Settings.mouse_filter = Control.MOUSE_FILTER_IGNORE


func _on_music_value_changed(value: float) -> void:
	var bus_index = AudioServer.get_bus_index("Music")
	if value > 0:
		AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
		AudioServer.set_bus_mute(bus_index, false)
	else:
		AudioServer.set_bus_mute(bus_index, true)

func _on_sfx_value_changed(value: float) -> void:
	var bus_index = AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))


func _on_master_value_changed(value: float) -> void:
	var bus_index = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
@onready var sound_settings = $Background/Sound_Settings
@onready var credit = $Background/CreditMenu
func open_settings():
	print("Открываю настройки")
	sound_settings.visible = true
	sound_settings.mouse_filter = Control.MOUSE_FILTER_STOP
	sound_settings.scale = Vector2(1, 0.8) 
	sound_settings.modulate.a = 0           
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(sound_settings, "modulate:a", 1.0, 0.3)
	tween.tween_property(sound_settings, "scale", Vector2.ONE, 0.4)\
		.set_trans(Tween.TRANS_BACK)\
		.set_ease(Tween.EASE_OUT)

func close_settings():
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(sound_settings, "modulate:a", 0.0, 0.2)
	tween.tween_property(sound_settings, "scale", Vector2(1, 0.8), 0.2)
	await tween.finished
	sound_settings.visible = false
func open_credit():
	credit.visible = true
	credit.mouse_filter = Control.MOUSE_FILTER_STOP
	credit.scale = Vector2(1, 0.8) 
	credit.modulate.a = 0           
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(credit, "modulate:a", 1.0, 0.3)
	tween.tween_property(credit, "scale", Vector2.ONE, 0.4)\
		.set_trans(Tween.TRANS_BACK)\
		.set_ease(Tween.EASE_OUT)

func close_credit():
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(credit, "modulate:a", 0.0, 0.2)
	tween.tween_property(credit, "scale", Vector2(1, 0.8), 0.2)
	await tween.finished
	credit.visible = false
